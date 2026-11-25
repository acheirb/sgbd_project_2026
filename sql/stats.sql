PREPARE nb_total_emprunts AS (
    SELECT v.reference, COUNT(emp) as emprunts, COUNT(DISTINCT emp.id_adherent) as adherents FROM velo v
    LEFT JOIN emprunt emp on emp.reference = v.reference AND emp.date_heure_depart >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY v.reference
);

PREPARE velo_2 (DATE) AS (
    SELECT v.reference, ROUND(SUM(emp.distance_parcourue),2) as distance_totale, ROUND(AVG(emp.distance_parcourue),2) as distance_moyenne FROM velo v
    JOIN emprunt emp on emp.reference = v.reference
    AND (emp.date_heure_depart BETWEEN $1 - INTERVAL '7 days' AND $1) 
    GROUP BY v.reference
);

PREPARE utilisation_velos AS (
    SELECT v.*, COUNT(e.id_station_arrivee) AS nb_trajets FROM velo v
    JOIN emprunt e USING (reference)
    WHERE (e.date_heure_depart >= CURRENT_DATE - INTERVAL '30 days')
    GROUP BY v.reference
    HAVING COUNT(e.id_station_arrivee) >= 10
    ORDER BY nb_trajets DESC
);

PREPARE frequentation_stations(INTEGER) AS (
    SELECT s.id_station, s.nom_station,
        (SELECT COUNT(*) FROM emprunt e
         WHERE e.id_station_depart = s.id_station
           AND EXTRACT(MONTH FROM e.date_heure_depart) = $1
           AND EXTRACT(YEAR  FROM e.date_heure_depart) = EXTRACT(YEAR FROM CURRENT_DATE)
        ) AS nb_departs,
        (SELECT COUNT(*) FROM emprunt e
         WHERE e.id_station_arrivee = s.id_station
           AND EXTRACT(MONTH FROM e.date_heure_arrivee) = $1
           AND EXTRACT(YEAR  FROM e.date_heure_arrivee) = EXTRACT(YEAR FROM CURRENT_DATE)
        ) AS nb_arrivees
    FROM station s
    ORDER BY s.id_station
);

PREPARE stats_maintenance AS (
    SELECT i.reference, COUNT(*) AS nb_interventions, SUM(i.duree_heures) AS duree_indisponibilite FROM intervention i
    WHERE i.date_intervention >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY i.reference
    ORDER BY nb_interventions DESC
);

PREPARE classement_stations AS (
    SELECT nom_commune, nom_station, nb_departs FROM (
        SELECT c.nom_commune, s.nom_station, COUNT(e.id_emprunt) AS nb_departs,
            RANK() OVER (PARTITION BY c.id_commune ORDER BY COUNT(e.id_emprunt) DESC) AS rang
        FROM station s
        JOIN commune c ON c.id_commune = s.id_commune
        LEFT JOIN emprunt e ON e.id_station_depart = s.id_station AND e.date_heure_depart >= CURRENT_DATE - INTERVAL '30 days'
        GROUP BY c.id_commune, c.nom_commune, s.id_station, s.nom_station
    ) AS t
    WHERE rang <= 3
    ORDER BY nom_commune, nb_departs DESC
);
