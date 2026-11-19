<?php
require __DIR__ . '/db.php';

$requetes = [
    [
        'titre'  => "1. Stations d'une commune",
        'params' => ['commune'],
        'sql'    => "
            SELECT s.nom_station AS station, s.adresse_station AS adresse,
                   s.nb_bornes AS capacite,
                   COUNT(v.reference) AS velos_presents,
                   s.nb_bornes - COUNT(v.reference) AS places_libres
            FROM station s
            LEFT JOIN velo v ON v.id_station = s.id_station
            WHERE s.id_commune = :commune
            GROUP BY s.id_station, s.nom_station, s.adresse_station, s.nb_bornes
            ORDER BY s.nom_station",
    ],
    [
        'titre'  => "2. Vélos disponibles d'une station",
        'params' => ['station'],
        'sql'    => "
            SELECT v.reference, m.marque, m.nom_modele AS modele,
                   v.niveau_batterie AS batterie, v.kilometrage
            FROM velo v
            JOIN modele m ON m.id_modele = v.id_modele
            WHERE v.id_station = :station AND v.etat = 'disponible'
            ORDER BY v.niveau_batterie DESC",
    ],
    [
        'titre' => '3. Stations avec au moins 2 vélos disponibles à plus de 50 %',
        'sql'   => "
            SELECT s.nom_station AS station, c.nom_commune AS commune, COUNT(*) AS nb_velos
            FROM station s
            JOIN commune c ON c.id_commune = s.id_commune
            JOIN velo v    ON v.id_station = s.id_station
            WHERE v.etat = 'disponible' AND v.niveau_batterie > 50
            GROUP BY s.id_station, s.nom_station, c.nom_commune
            HAVING COUNT(*) >= 2
            ORDER BY nb_velos DESC",
    ],
    [
        'titre' => "4. Vélos en cours d'utilisation",
        'sql'   => "
            SELECT e.reference, s.nom_station AS station_depart,
                   e.date_heure_depart AS debut, a.prenom || ' ' || a.nom AS adherent
            FROM emprunt e
            JOIN station s  ON s.id_station = e.id_station_depart
            JOIN adherent a ON a.id_adherent = e.id_adherent
            WHERE e.date_heure_retour IS NULL
            ORDER BY e.date_heure_depart",
    ],
    [
        'titre'  => "5. Historique des emprunts d'un adhérent",
        'params' => ['adherent'],
        'sql'    => "
            SELECT e.reference, sd.nom_station AS depart, e.date_heure_depart,
                   sa.nom_station AS arrivee, e.date_heure_retour,
                   e.distance_parcourue AS distance_km
            FROM emprunt e
            JOIN station sd      ON sd.id_station = e.id_station_depart
            LEFT JOIN station sa ON sa.id_station = e.id_station_arrivee
            WHERE e.id_adherent = :adherent
            ORDER BY e.date_heure_depart DESC",
    ],
    [
        'titre' => '6. Adhérents ayant pris 2 vélos différents le même jour',
        'sql'   => "
            SELECT a.nom, a.prenom, CAST(e.date_heure_depart AS DATE) AS jour,
                   COUNT(DISTINCT e.reference) AS nb_velos
            FROM adherent a
            JOIN emprunt e ON e.id_adherent = a.id_adherent
            GROUP BY a.id_adherent, a.nom, a.prenom, CAST(e.date_heure_depart AS DATE)
            HAVING COUNT(DISTINCT e.reference) >= 2
            ORDER BY jour DESC",
    ],
    [
        'titre' => '7. Vélos jamais empruntés',
        'sql'   => "
            SELECT v.reference, v.etat, v.date_mise_service
            FROM velo v
            WHERE NOT EXISTS (SELECT 1 FROM emprunt e WHERE e.reference = v.reference)
            ORDER BY v.reference",
    ],
    [
        'titre' => '8. Vélos en maintenance et dernière intervention',
        'sql'   => "
            SELECT v.reference, i.date_intervention, i.nature, i.duree_heures
            FROM velo v
            LEFT JOIN intervention i ON i.reference = v.reference
                 AND i.date_intervention = (SELECT MAX(i2.date_intervention)
                                            FROM intervention i2
                                            WHERE i2.reference = v.reference)
            WHERE v.etat = 'maintenance'
            ORDER BY v.reference",
    ],
    [
        'titre'  => "9. Interventions d'un vélo",
        'params' => ['velo'],
        'sql'    => "
            SELECT date_intervention, nature, duree_heures
            FROM intervention
            WHERE reference = :velo
            ORDER BY date_intervention DESC",
    ],
    [
        'titre' => '10. État des adhésions (valables 1 an)',
        'sql'   => "
            SELECT nom, prenom, date_adhesion,
                   CAST(date_adhesion + INTERVAL '1 year' AS DATE) AS date_fin,
                   date_adhesion + INTERVAL '1 year' >= CURRENT_DATE AS valide
            FROM adherent
            ORDER BY date_fin",
    ],
];

entete('Consultations');
page_requetes($requetes);
pied();
