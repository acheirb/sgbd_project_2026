
<?php
// statistiques.php : les 6 requêtes statistiques de l'énoncé.
require __DIR__ . '/db.php';

$requetes = [
    [
        'titre' => '1. Utilisation des vélos (30 derniers jours)',
        'sql'   => "
            SELECT v.reference,
                   COUNT(e.id_emprunt) AS nb_emprunts,
                   COUNT(DISTINCT e.id_adherent) AS nb_adherents
            FROM velo v
            LEFT JOIN emprunt e ON e.reference = v.reference
                 AND e.date_heure_depart >= CURRENT_DATE - INTERVAL '30 days'
            GROUP BY v.reference
            ORDER BY nb_emprunts DESC, v.reference",
    ],
    [
        'titre'  => "2. Distances parcourues pendant une semaine",
        'params' => ['date'],
        'sql'    => "
            WITH semaine AS (SELECT DATE_TRUNC('week', CAST(:date AS DATE)) AS debut)
            SELECT v.reference,
                   COUNT(e.id_emprunt) AS nb_trajets,
                   COALESCE(SUM(e.distance_parcourue), 0) AS distance_totale,
                   COALESCE(ROUND(AVG(e.distance_parcourue), 2), 0) AS distance_moyenne
            FROM velo v
            CROSS JOIN semaine s
            LEFT JOIN emprunt e ON e.reference = v.reference
                 AND e.date_heure_depart >= s.debut
                 AND e.date_heure_depart <  s.debut + INTERVAL '7 days'
            GROUP BY v.reference
            ORDER BY distance_totale DESC, v.reference",
    ],
    [
        'titre' => '3. Vélos fortement utilisés (10 trajets ou plus en 30 jours)',
        'sql'   => "
            SELECT reference, COUNT(*) AS nb_trajets
            FROM emprunt
            WHERE date_heure_depart >= CURRENT_DATE - INTERVAL '30 days'
            GROUP BY reference
            HAVING COUNT(*) >= 10
            ORDER BY nb_trajets DESC",
    ],
    [
        'titre'  => "4. Fréquentation des stations pendant un mois",
        'params' => ['mois'],
        'sql'    => "
            WITH mois AS (SELECT TO_DATE(:mois, 'YYYY-MM') AS debut)
            SELECT s.nom_station AS station,
                   (SELECT COUNT(*) FROM emprunt e
                    WHERE e.id_station_depart = s.id_station
                      AND e.date_heure_depart >= m.debut
                      AND e.date_heure_depart <  m.debut + INTERVAL '1 month') AS nb_departs,
                   (SELECT COUNT(*) FROM emprunt e
                    WHERE e.id_station_arrivee = s.id_station
                      AND e.date_heure_arrivee >= m.debut
                      AND e.date_heure_arrivee <  m.debut + INTERVAL '1 month') AS nb_arrivees
            FROM station s
            CROSS JOIN mois m
            ORDER BY s.nom_station",
    ],
    [
        'titre' => "5. Maintenance sur l'année écoulée",
        'sql'   => "
            SELECT reference,
                   COUNT(*) AS nb_interventions,
                   SUM(duree_heures) AS duree_totale_heures
            FROM intervention
            WHERE date_intervention >= CURRENT_DATE - INTERVAL '1 year'
            GROUP BY reference
            ORDER BY duree_totale_heures DESC",
    ],
    [
        'titre' => '6. Top 3 des stations par commune (départs, 30 jours)',
        'sql'   => "
            SELECT commune, station, nb_departs, rang
            FROM (SELECT c.nom_commune AS commune, s.nom_station AS station,
                         COUNT(e.id_emprunt) AS nb_departs,
                         ROW_NUMBER() OVER (PARTITION BY c.id_commune
                                            ORDER BY COUNT(e.id_emprunt) DESC, s.nom_station) AS rang
                  FROM station s
                  JOIN commune c ON c.id_commune = s.id_commune
                  LEFT JOIN emprunt e ON e.id_station_depart = s.id_station
                       AND e.date_heure_depart >= CURRENT_DATE - INTERVAL '30 days'
                  GROUP BY c.id_commune, c.nom_commune, s.id_station, s.nom_station) t
            WHERE rang <= 3
            ORDER BY commune, rang",
    ],
];

entete('Statistiques');
page_requetes($requetes);
pied();
