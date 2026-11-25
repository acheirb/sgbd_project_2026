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
