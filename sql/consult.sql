--Liste des stations situées dans une commune donnée, avec leur capacité, le nombre de vélos
--présents et le nombre de places disponibles, ici la station 1;

-- SELECT s.id_station,s.nom_station, s.nb_bornes - COUNT(*) FROM velo v JOIN station s ON s.id_station = v.id_station AS 'nb de vélos disponibles' , s.nb_bornes
-- FROM  station s 
-- WHERE s.id_station = 1;

SELECT s.id_station, s.nom_station,
       s.nb_bornes                       AS capacite,
       COUNT(v.reference)                AS nb_velos_presents,
       s.nb_bornes - COUNT(v.reference)  AS nb_places_disponibles
FROM station s
JOIN commune c     ON c.id_commune = s.id_commune
LEFT JOIN velo v   ON v.id_station = s.id_station
WHERE c.nom_commune = 'Pessac'
GROUP BY s.id_station, s.nom_station, s.nb_bornes
ORDER BY s.nom_station;
-- Liste des vélos disponibles dans une station donnée, classés par niveau de charge décroissant.
SELECT * FROM velo
WHERE id_station = 1 AND etat ='disponible'
ORDER BY niveau_batterie DESC;


--Liste des stations disposant d’au moins deux vélos disponibles dont le niveau de batterie
--est supérieur à 50

-- SELECT s.id_station,s.nom_station,s.nb_bornes 
-- FROM velo v
-- JOIN station s ON s.id_station = v.id_station
-- GROUP BY s.id_station,s.nom_station,s.nb_bornes
-- HAVING s.nb_bornes - COUNT(SELECT * FROM velo WHERE niveau_batterie > 50 AND etat = 'disponible' ) >=  2;
SELECT s.id_station, s.nom_station, COUNT(v.reference) AS nb_velos
FROM velo v
JOIN station s ON s.id_station = v.id_station
WHERE v.etat = 'disponible'
  AND v.niveau_batterie > 50
GROUP BY s.id_station, s.nom_station
HAVING COUNT(v.reference) >= 2
ORDER BY s.id_station;
--Liste des vélos actuellement en cours d’utilisation, avec leur station de départ et l’heure de
--début de l’emprunt.

SELECT v.reference, e.date_heure_depart,e.id_station_depart FROM velo v
JOIN emprunt e ON e.reference = v.reference
WHERE v.etat = 'en_utilisation' and e.date_heure_retour IS NULL
GROUP BY v.reference,e.date_heure_depart,e.id_station_depart;

--— Historique des emprunts d’un adhérent, avec les stations de départ et d’arrivée, les dates et
--les distances parcourues. par exemple ici l adherent 1 
SELECT sd.nom_station AS "station depart",sa.nom_station AS "station arrivee", e.date_heure_depart,e.date_heure_retour,e.distance_parcourue 
FROM emprunt e
JOIN station sd ON e.id_station_depart = sd.id_station
LEFT JOIN station sa ON e.id_station_arrivee = sa.id_station
WHERE e.id_adherent = 1
