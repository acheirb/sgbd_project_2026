-- Emprunter un vélo : la station de départ est celle où le vélo est garé.
-- Les règles (disponibilité, batterie, adhésion...) sont contrôlées par trg_emprunt_depart.
CREATE OR REPLACE FUNCTION emprunter(p_id_adherent INTEGER, p_reference VARCHAR)
RETURNS INTEGER AS $$
    INSERT INTO emprunt (id_adherent, reference, id_station_depart)
    SELECT p_id_adherent, v.reference, v.id_station FROM velo v WHERE v.reference = p_reference
    RETURNING id_emprunt;
$$ LANGUAGE SQL;

-- Restituer un vélo dans une station. Sans distance précisée, on prend celle de la
-- table distance (NULL si la paire de stations n'y figure pas).
-- Le vélo est ensuite garé et son kilométrage mis à jour par trg_emprunt_arrivee.
CREATE OR REPLACE FUNCTION restituer(p_reference VARCHAR, p_station INTEGER, p_distance NUMERIC DEFAULT NULL)
RETURNS INTEGER AS $$
    UPDATE emprunt e
    SET id_station_arrivee = p_station,
        date_heure_arrivee = clock_timestamp(),
        distance_parcourue = COALESCE(p_distance,
            (SELECT d.distance_km FROM distance d
             WHERE d.station_a = LEAST(e.id_station_depart, p_station)
               AND d.station_b = GREATEST(e.id_station_depart, p_station)))
    WHERE e.reference = p_reference AND e.date_heure_arrivee IS NULL
    RETURNING e.id_emprunt;
$$ LANGUAGE SQL;

-- Mettre un vélo en maintenance et enregistrer l'intervention (date du jour).
-- Le vélo quitte sa station. Refusé s'il est en cours d'utilisation.
-- Renvoie l'identifiant de l'intervention créée.
CREATE OR REPLACE FUNCTION mettre_en_maintenance(p_reference VARCHAR, p_nature VARCHAR, p_duree NUMERIC)
RETURNS INTEGER AS $$
DECLARE
    v_etat velo.etat%TYPE;
    v_id   INTEGER;
BEGIN
    SELECT etat INTO v_etat FROM velo WHERE reference = p_reference FOR UPDATE;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Vélo % inconnu', p_reference;
    END IF;
    IF v_etat = 'en_utilisation' THEN
        RAISE EXCEPTION 'Le vélo % est en cours d''utilisation', p_reference;
    END IF;

    UPDATE velo SET etat = 'maintenance', id_station = NULL WHERE reference = p_reference;
    INSERT INTO intervention (date_intervention, nature, duree_heures, reference)
    VALUES (CURRENT_DATE, p_nature, p_duree, p_reference)
    RETURNING id_intervention INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Remettre en service un vélo en maintenance : il est garé dans la station indiquée
-- (capacité contrôlée par trg_velo_capacite).
CREATE OR REPLACE FUNCTION terminer_maintenance(p_reference VARCHAR, p_station INTEGER)
RETURNS VOID AS $$
DECLARE
    v_etat velo.etat%TYPE;
BEGIN
    SELECT etat INTO v_etat FROM velo WHERE reference = p_reference FOR UPDATE;
    IF v_etat IS DISTINCT FROM 'maintenance' THEN
        RAISE EXCEPTION 'Le vélo % n''est pas en maintenance (état : %)', p_reference, v_etat;
    END IF;
    UPDATE velo SET etat = 'disponible', id_station = p_station WHERE reference = p_reference;
END;
$$ LANGUAGE plpgsql;

-- Renouveler l'adhésion d'un adhérent : elle repart de la date du jour pour un an
-- (hypothèse : une seule date d'adhésion est conservée, l'ancienne est écrasée).
-- Renvoie la nouvelle date de fin.
CREATE OR REPLACE FUNCTION renouveler_adhesion(p_id_adherent INTEGER)
RETURNS DATE AS $$
    UPDATE adherent SET date_adhesion = CURRENT_DATE
    WHERE id_adherent = p_id_adherent
    RETURNING CAST(date_adhesion + INTERVAL '1 year' AS DATE);
$$ LANGUAGE SQL;

-- Rééquilibrer : déplacer jusqu'à p_nb vélos disponibles (les mieux chargés d'abord)
-- d'une station vers une autre. La capacité de la station d'arrivée est contrôlée par
-- trg_velo_capacite : si elle est dépassée, aucun vélo n'est déplacé.
-- Renvoie le nombre de vélos déplacés.
CREATE OR REPLACE FUNCTION deplacer_velos(p_depart INTEGER, p_arrivee INTEGER, p_nb INTEGER)
RETURNS INTEGER AS $$
    WITH choisis AS (
        SELECT reference FROM velo
        WHERE id_station = p_depart AND etat = 'disponible'
        ORDER BY niveau_batterie DESC
        LIMIT p_nb
        FOR UPDATE
    ),
    deplaces AS (
        UPDATE velo SET id_station = p_arrivee
        WHERE reference IN (SELECT reference FROM choisis)
        RETURNING reference
    )
    SELECT CAST(COUNT(*) AS INTEGER) FROM deplaces;
$$ LANGUAGE SQL;
