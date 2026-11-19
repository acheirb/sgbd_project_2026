
BEGIN;

-- Communes de Bordeaux Métropole 
INSERT INTO commune (nom_commune, code_postal) VALUES
    ('Bordeaux',           '33000'),
    ('Talence',            '33400'),
    ('Pessac',             '33600'),
    ('Mérignac',           '33700'),
    ('Bègles',             '33130'),
    ('Cenon',              '33150'),
    ('Gradignan',          '33170'),
    ('Le Bouscat',         '33110');


-- Modèles de vélos électriques 
INSERT INTO modele (nom_modele, marque) VALUES
    ('CityCruiser V2', 'Urbanix'),
    ('UrbanGlide Pro', 'Voltena'),
    ('CargoLite',      'Urbanix'),
    ('Trek Mob 3',     'Rideon');


-- 50 stations réparties sur la métropole (capacité de 16 à 32 bornes)
INSERT INTO station (nom_station, adresse_station, latitude, longitude, nb_bornes, id_commune)
SELECT
    (ARRAY[
        'Quinconces', 'Victoire', 'Saint-Jean', 'Chartrons', 'Bastide',
        'Peixotto', 'Forum', 'Arts et Métiers', 'Doyen Brus', 'Mériadeck',
        'Gambetta', 'Pey-Berland', 'Capucins', 'Stalingrad', 'Ravezies',
        'Barrière de Pessac', 'Gare Alouette', 'Mérignac Soleil', 'Terres Neuves', 'Parc Bordelais'
    ])[1 + ((i - 1) % 20)] || ' ' || ((i - 1) / 20 + 1),
    (1 + (i * 7) % 150) || ' ' ||
    (ARRAY[
        'Cours de la Libération', 'Cours Victor Hugo', 'Avenue de la République',
        'Allées de Tourny', 'Rue Sainte-Catherine', 'Cours Gambetta',
        'Avenue Jean Jaurès', 'Quai des Chartrons'
    ])[1 + (i % 8)],
    ROUND((44.7850 + random() * 0.0850)::numeric, 6),
    ROUND((-0.6500 + random() * 0.1200)::numeric, 6),
    16 + (floor(random() * 5)::int * 4),
    1 + (i % 8)
FROM generate_series(1, 50) AS i;


-- Distances entre stations (formule de Haversine sur les couples proches)
INSERT INTO distance (station_a, station_b, distance_km)
SELECT
    s1.id_station,
    s2.id_station,
    GREATEST(0.20, ROUND((6371 * 2 * ASIN(SQRT(
        POWER(SIN(RADIANS(s2.latitude - s1.latitude) / 2), 2) +
        COS(RADIANS(s1.latitude)) * COS(RADIANS(s2.latitude)) *
        POWER(SIN(RADIANS(s2.longitude - s1.longitude) / 2), 2)
    )))::numeric, 2))
FROM station s1
JOIN station s2 ON s1.id_station < s2.id_station
WHERE (s2.id_station - s1.id_station) <= 5;


-- 600 vélos électriques avec distribution réaliste de batterie et d'état
--    (les vélos V0596 à V0600 restent neufs et jamais empruntés)
INSERT INTO velo (reference, date_mise_service, kilometrage, etat, niveau_batterie, id_modele, id_station)
SELECT
    'V' || lpad(i::text, 4, '0'),
    CURRENT_DATE - (floor(random() * 900)::int),
    ROUND((random() * 4500)::numeric, 1),
    etat_velo,
    CASE
        WHEN etat_velo = 'hors_service' THEN 0
        WHEN random() < 0.12 THEN floor(random() * 20)::int
        ELSE 35 + floor(random() * 66)::int
    END,
    1 + (i % 4),
    CASE
        WHEN etat_velo = 'disponible' THEN 1 + ((i - 1) % 50)
        ELSE NULL
    END
FROM (
    SELECT
        i,
        CASE
            WHEN i BETWEEN 581 AND 595 THEN 'en_utilisation'
            WHEN i > 595               THEN 'disponible'
            WHEN random() < 0.07       THEN 'maintenance'
            WHEN random() < 0.02       THEN 'hors_service'
            ELSE 'disponible'
        END AS etat_velo
    FROM generate_series(1, 600) AS i
) sub;


--  1500 adhérents inscrits dans la métropole
INSERT INTO adherent (nom, prenom, adresse, email, telephone, date_adhesion, id_commune)
SELECT
    (ARRAY[
        'Martin', 'Bernard', 'Dubois', 'Thomas', 'Robert',
        'Richard', 'Petit', 'Durand', 'Leroy', 'Moreau',
        'Simon', 'Laurent', 'Lefebvre', 'Michel', 'Garcia',
        'David', 'Bertrand', 'Roux', 'Vincent', 'Fournier'
    ])[1 + (i % 20)],
    (ARRAY[
        'Léa', 'Hugo', 'Inès', 'Lucas', 'Chloé',
        'Nathan', 'Manon', 'Yanis', 'Emma', 'Louis',
        'Camille', 'Gabriel', 'Jade', 'Arthur', 'Sarah',
        'Jules', 'Alice', 'Adam', 'Lina', 'Noah'
    ])[1 + ((i / 20) % 20)],
    (1 + (i * 3) % 120) || ' ' ||
    (ARRAY[
        'rue Peydavant', 'avenue Jean Jaurès', 'cours de l''Argonne',
        'rue Roustaing', 'avenue Pasteur', 'cours de la Somme',
        'rue Sainte-Catherine', 'avenue de la Marne'
    ])[1 + (i % 8)],
    'adherent' || i || '@bordeaux-velos.fr',
    '06' || lpad(i::text, 8, '0'),
    CURRENT_DATE - (floor(random() * 500)::int),
    1 + (i % 8)
FROM generate_series(1, 1500) AS i;


-- 20 000 emprunts historiques sur 90 jours (avec pics aux heures de pointe)
INSERT INTO emprunt (id_adherent, reference, id_station_depart, id_station_arrivee,
                     date_heure_depart, date_heure_retour, distance_parcourue)
SELECT
    1 + floor(random() * 1480)::int,
    'V' || lpad((1 + floor(random() * 580)::int)::text, 4, '0'),
    1 + floor(random() * 50)::int,
    1 + floor(random() * 50)::int,
    ts,
    ts + (duration_min || ' minutes')::interval,
    ROUND((duration_min * (0.22 + random() * 0.10))::numeric, 2)
FROM (
    SELECT
        (CURRENT_DATE - (1 + floor(random() * 90)::int))
            + (CASE
                WHEN random() < 0.45 THEN 7  + floor(random() * 3)::int   -- Pointe du matin (7h-9h)
                WHEN random() < 0.85 THEN 17 + floor(random() * 3)::int   -- Pointe du soir (17h-19h)
                ELSE 10 + floor(random() * 7)::int                        -- Journée (10h-16h)
               END || ' hours')::interval
            + (floor(random() * 60)::int || ' minutes')::interval AS ts,
        6 + floor(random() * 25)::int AS duration_min
    FROM generate_series(1, 20000)
) sub;

-- 15 emprunts actuellement en cours (vélos V0581 à V0595)
INSERT INTO emprunt (id_adherent, reference, id_station_depart, id_station_arrivee,
                     date_heure_depart, date_heure_retour, distance_parcourue)
SELECT
    1480 + i,
    'V' || lpad((580 + i)::text, 4, '0'),
    1 + (i % 50),
    NULL,
    CURRENT_TIMESTAMP - ((5 + i * 2) || ' minutes')::interval,
    NULL,
    NULL
FROM generate_series(1, 15) AS i;


-- 300 interventions de maintenance sur l'année écoulée
INSERT INTO intervention (reference, date_intervention, nature, duree_heures)
SELECT
    'V' || lpad((1 + floor(random() * 580)::int)::text, 4, '0'),
    CURRENT_DATE - (floor(random() * 365)::int),
    (ARRAY[
        'Révision générale',
        'Remplacement de la batterie',
        'Crevaison roue arrière',
        'Freins défectueux',
        'Changement de chaîne',
        'Réglage du dérailleur',
        'Diagnostic moteur électrique',
        'Éclairage avant hors service'
    ])[1 + (i % 8)],
    ROUND((0.5 + floor(random() * 12) * 0.5)::numeric, 2)
FROM generate_series(1, 300) AS i;

-- Garantit que chaque vélo actuellement en maintenance possède une intervention récente
INSERT INTO intervention (reference, date_intervention, nature, duree_heures)
SELECT
    reference,
    CURRENT_DATE - (floor(random() * 7)::int),
    'Maintenance préventive et diagnostic batterie',
    2.5
FROM velo
WHERE etat = 'maintenance';

COMMIT;
