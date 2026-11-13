-- Hypothèses : batterie min = 20 %, adhésion valable 1 an.

--  Stations d'une commune : capacité, vélos présents, places libres
SELECT s.nom_station, s.nb_bornes, COUNT(v.reference) AS nb_velos,
       s.nb_bornes - COUNT(v.reference) AS places_libres
FROM station s
JOIN commune c   ON c.id_commune = s.id_commune
LEFT JOIN velo v ON v.id_station = s.id_station
WHERE c.nom_commune = 'Talence'
GROUP BY s.id_station, s.nom_station, s.nb_bornes;

-- Vélos disponibles d'une station, par batterie décroissante
SELECT v.reference, v.niveau_batterie
FROM velo v
JOIN station s ON s.id_station = v.id_station
WHERE s.nom_station = 'Talence Centre' AND v.etat = 'disponible'
ORDER BY v.niveau_batterie DESC;

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
SELECT e.reference, sd.nom_station AS depart, e.date_heure_depart,
       sa.nom_station AS arrivee, e.date_heure_retour, e.distance_parcourue
FROM emprunt e
JOIN adherent a      ON a.id_adherent = e.id_adherent
JOIN station sd      ON sd.id_station = e.id_station_depart
LEFT JOIN station sa ON sa.id_station = e.id_station_arrivee
WHERE a.nom = 'Petit' AND a.prenom = 'Lucas'
ORDER BY e.date_heure_depart DESC;

-- Adhérents ayant emprunté 2 vélos différents le même jour
SELECT a.nom, a.prenom, CAST(e.date_heure_depart AS DATE) AS jour
FROM adherent a
JOIN emprunt e ON e.id_adherent = a.id_adherent
GROUP BY a.id_adherent, a.nom, a.prenom, CAST(e.date_heure_depart AS DATE)
HAVING COUNT(DISTINCT e.reference) >= 2;

-- Vélos jamais empruntés
SELECT v.reference
FROM velo v
WHERE v.reference NOT IN (SELECT reference FROM emprunt);

-- Vélos en maintenance avec leur dernière intervention
SELECT v.reference, i.date_intervention, i.nature, i.duree_heures
FROM velo v
LEFT JOIN intervention i ON i.reference = v.reference
 AND i.date_intervention = (SELECT MAX(date_intervention)
                            FROM intervention WHERE reference = v.reference)
WHERE v.etat = 'maintenance';

--  Chercher une station par nom de commune (recherche partielle)
SELECT c.nom_commune, s.nom_station, s.adresse_station
FROM station s
JOIN commune c ON c.id_commune = s.id_commune
WHERE c.nom_commune ILIKE '%pess%';

-- Adhésion d'un adhérent : date de fin et validité
SELECT a.nom, a.prenom, a.date_adhesion,
       CAST(a.date_adhesion + INTERVAL '1 year' AS DATE) AS date_fin,
       a.date_adhesion + INTERVAL '1 year' >= CURRENT_DATE AS valide
FROM adherent a
WHERE a.nom = 'Moreau' AND a.prenom = 'Yanis';

-- Vélos empruntables (disponible, en station, batterie >= 20 %),les plus récents en premier   
SELECT v.reference, s.nom_station, v.niveau_batterie, v.date_mise_service
FROM velo v
JOIN station s ON s.id_station = v.id_station
WHERE v.etat = 'disponible' AND v.niveau_batterie >= 20
ORDER BY v.date_mise_service DESC;

-- Durée  de chaque trajet terminé
SELECT e.id_emprunt, e.reference, e.distance_parcourue,
       EXTRACT(EPOCH FROM e.date_heure_retour - e.date_heure_depart) / 60 AS duree_min
FROM emprunt e
WHERE e.date_heure_retour IS NOT NULL;
