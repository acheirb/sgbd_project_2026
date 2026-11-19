-- Hypothèses : batterie min = 20 %, adhésion valable 1 an.

-- Stations d'une commune : capacité, vélos, places libres
CREATE OR REPLACE FUNCTION stations_commune(p_commune VARCHAR)
RETURNS TABLE (commune VARCHAR, station VARCHAR, nb_bornes INTEGER,
               nb_velos BIGINT, places_libres BIGINT) AS $$
    SELECT c.nom_commune, s.nom_station, s.nb_bornes, COUNT(v.reference),
           s.nb_bornes - COUNT(v.reference)
    FROM station s
    JOIN commune c   ON c.id_commune = s.id_commune
    LEFT JOIN velo v ON v.id_station = s.id_station
    WHERE c.nom_commune ILIKE '%' || p_commune || '%'
    GROUP BY c.nom_commune, s.id_station, s.nom_station, s.nb_bornes;
$$ LANGUAGE SQL;

-- Vélos disponibles d'une station, par batterie décroissante
CREATE OR REPLACE FUNCTION velos_station(p_station VARCHAR)
RETURNS TABLE (reference VARCHAR, niveau_batterie INTEGER) AS $$
    SELECT v.reference, v.niveau_batterie
    FROM velo v
    JOIN station s ON s.id_station = v.id_station
    WHERE s.nom_station = p_station AND v.etat = 'disponible'
    ORDER BY v.niveau_batterie DESC;
$$ LANGUAGE SQL;

-- Stations avec au moins 2 vélos disponibles à plus de 50 %
SELECT s.nom_station, COUNT(*) AS nb_velos
FROM station s
JOIN velo v ON v.id_station = s.id_station
WHERE v.etat = 'disponible' AND v.niveau_batterie > 50
GROUP BY s.id_station, s.nom_station
HAVING COUNT(*) >= 2;

-- Vélos en cours d'utilisation : station et heure de départ
SELECT e.reference, s.nom_station, e.date_heure_depart
FROM emprunt e
JOIN station s ON s.id_station = e.id_station_depart
WHERE e.date_heure_retour IS NULL;

-- Historique des emprunts d'un adhérent
CREATE OR REPLACE FUNCTION historique_adherent(p_nom VARCHAR, p_prenom VARCHAR)
RETURNS TABLE (reference VARCHAR, depart VARCHAR, date_depart TIMESTAMP,
               arrivee VARCHAR, date_retour TIMESTAMP, distance NUMERIC) AS $$
    SELECT e.reference, sd.nom_station, e.date_heure_depart,
           sa.nom_station, e.date_heure_retour, e.distance_parcourue
    FROM emprunt e
    JOIN adherent a      ON a.id_adherent = e.id_adherent
    JOIN station sd      ON sd.id_station = e.id_station_depart
    LEFT JOIN station sa ON sa.id_station = e.id_station_arrivee
    WHERE a.nom = p_nom AND a.prenom = p_prenom
    ORDER BY e.date_heure_depart DESC;
$$ LANGUAGE SQL;

-- Adhérents ayant emprunté 2 vélos différents le même jour
SELECT a.nom, a.prenom, CAST(e.date_heure_depart AS DATE) AS jour
FROM adherent a
JOIN emprunt e ON e.id_adherent = a.id_adherent
GROUP BY a.id_adherent, a.nom, a.prenom, CAST(e.date_heure_depart AS DATE)
HAVING COUNT(DISTINCT e.reference) >= 2;

-- Vélos jamais empruntés
SELECT v.reference FROM velo v
WHERE v.reference NOT IN (SELECT reference FROM emprunt);

-- Vélos en maintenance avec leur dernière intervention
SELECT v.reference, i.date_intervention, i.nature, i.duree_heures
FROM velo v
LEFT JOIN intervention i ON i.reference = v.reference
 AND i.date_intervention = (SELECT MAX(date_intervention)
                            FROM intervention WHERE reference = v.reference)
WHERE v.etat = 'maintenance';

-- Adhésion d'un adhérent : date de fin et validité
CREATE OR REPLACE FUNCTION adhesion(p_nom VARCHAR, p_prenom VARCHAR)
RETURNS TABLE (date_adhesion DATE, date_fin DATE, valide BOOLEAN) AS $$
    SELECT a.date_adhesion, CAST(a.date_adhesion + INTERVAL '1 year' AS DATE),
           a.date_adhesion + INTERVAL '1 year' >= CURRENT_DATE
    FROM adherent a
    WHERE a.nom = p_nom AND a.prenom = p_prenom;
$$ LANGUAGE SQL;

--* Vélos empruntables (disponible, batterie >= 20 %), les plus récents d'abord
SELECT v.reference, s.nom_station, v.niveau_batterie, v.date_mise_service
FROM velo v
JOIN station s ON s.id_station = v.id_station
WHERE v.etat = 'disponible' AND v.niveau_batterie >= 20
ORDER BY v.date_mise_service DESC;

--* Durée (en minutes) de chaque trajet terminé
SELECT e.id_emprunt, e.reference, e.distance_parcourue,
       EXTRACT(EPOCH FROM e.date_heure_retour - e.date_heure_depart) / 60 AS duree_min
FROM emprunt e
WHERE e.date_heure_retour IS NOT NULL;
