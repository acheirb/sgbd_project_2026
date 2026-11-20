-- ============================================================
-- insert.sql : Données réalistes calibrées sur le bilan
--              "Observatoire des vélos 2025" (Bordeaux Métropole /
--              "Le Vélo par TBM", ex-V3 / VCub)
--
-- Chiffres clés TBM 2025 utilisés pour la génération :
--   * ~200 stations "Le Vélo par TBM" (repositionnées en intra-rocade)
--   * 2 235 545 emprunts en 2025 (+130 % vs 2024), 54 % en VAE
--   * Trajet moyen : 2,7 km pour ~12 minutes (vitesse ~13,5 km/h)
--   * Distribution géographique des usagers :
--       - 40 % Bordeaux (centre intra-boulevards / quais)
--       - 41 % 1re couronne (Talence, Pessac, Mérignac, Bègles,
--         Le Bouscat, Cenon, Floirac)
--       - 19 % 2e couronne (Gradignan, Villenave-d'Ornon, Bruges, Lormont)
--   * Comptages horaires d'enquête (7h15-9h15 et 16h30-18h30) et
--     axes majeurs : Pont de Pierre (~9 800 cycl./j), Quai Louis XVIII
--     (~5 500/j), Cours Victor Hugo (~3 400/j), Pont Chaban-Delmas
--     (~2 700/j), Bd Albert 1er (~2 700/j), Cours de l'Argonne (~2 380/j),
--     Cours Maréchal Gallieni Talence (~1 328/j).
-- ============================================================

BEGIN;

-- Communes de Bordeaux Métropole (12 communes : Bordeaux + 1re et 2e couronnes)
INSERT INTO commune (nom_commune, code_postal) VALUES
    ('Bordeaux',           '33000'),  -- 1 (Ville-centre : ~40 % des flux)
    ('Talence',            '33400'),  -- 2 (1re couronne)
    ('Pessac',             '33600'),  -- 3 (1re couronne)
    ('Mérignac',           '33700'),  -- 4 (1re couronne)
    ('Bègles',             '33130'),  -- 5 (1re couronne)
    ('Le Bouscat',         '33110'),  -- 6 (1re couronne)
    ('Cenon',              '33150'),  -- 7 (1re couronne rive droite)
    ('Floirac',            '33270'),  -- 8 (1re couronne rive droite)
    ('Gradignan',          '33170'),  -- 9 (2e couronne)
    ('Villenave-d''Ornon', '33140'),  -- 10 (2e couronne)
    ('Bruges',             '33520'),  -- 11 (2e couronne)
    ('Lormont',            '33310');  -- 12 (2e couronne rive droite)


-- Modèles de vélos de la flotte TBM / opérateurs métropolitains
--    (répartition aides & prêts TBM 2025 : ~67 % VAE, ~26 % cargo, ~7 % pliant/compact)
INSERT INTO modele (nom_modele, marque) VALUES
    ('Le Vélo Électrique 2.0', 'TBM Cykleo'),
    ('Le Vélo Cargo VAE',      'TBM Babboe'),
    ('Le Vélo Compact Pliant', 'TBM Brompton'),
    ('UrbanGlide VAE Pro',     'Pony Bordeaux');


-- 200 stations "Le Vélo par TBM" (objectif fin 2025 intra-rocade)
-- Adresses issues des points de comptage officiels de l'Observatoire 2025
INSERT INTO station (nom_station, adresse_station, latitude, longitude, nb_bornes, id_commune)
SELECT
    base.nom || CASE WHEN i > 25 THEN ' #' || ((i - 1) / 25 + 1) ELSE '' END,
    (1 + (i * 7) % 140) || ' ' || base.axe,
    ROUND((base.lat + (random() - 0.5) * 0.0120)::numeric, 6),
    ROUND((base.lon + (random() - 0.5) * 0.0150)::numeric, 6),
    16 + (floor(random() * 5)::int * 4),   -- 16 à 32 bornes par station
    base.id_commune
FROM generate_series(1, 200) AS i
CROSS JOIN LATERAL (
    SELECT * FROM (VALUES
        (1,  'Pont de Pierre - Stalingrad',  'Place Stalingrad',                      44.8389, -0.5622, 1),
        (2,  'Quai Louis XVIII - Quinconces','Quai Louis XVIII',                      44.8452, -0.5705, 1),
        (3,  'Cours Victor Hugo',            'Cours Victor Hugo',                     44.8351, -0.5714, 1),
        (4,  'Pont Chaban-Delmas - Bacalan', 'Quai de Bacalan',                       44.8582, -0.5535, 1),
        (5,  'CAP Sciences - Hangars',       'Quai de Bacalan',                       44.8598, -0.5542, 1),
        (6,  'Boulevard Albert 1er',         'Boulevard Albert 1er',                  44.8210, -0.5655, 1),
        (7,  'Cours de l''Argonne',          'Cours de l''Argonne',                   44.8265, -0.5762, 1),
        (8,  'Place de la Victoire',         'Cours de la Somme',                     44.8306, -0.5728, 1),
        (9,  'Allées de Tourny',             'Allées de Tourny',                      44.8435, -0.5772, 1),
        (10, 'Hôtel de Ville - Pey-Berland', 'Rue Maréchal Joffre',                   44.8378, -0.5795, 1),
        (11, 'Gare Saint-Jean - Belcier',    'Rue Charles Domercq',                   44.8258, -0.5562, 1),
        (12, 'Pont Simone Veil',             'Quai de Paludate',                      44.8224, -0.5480, 1),
        (13, 'Avenue Thiers - Bastide',      'Avenue Thiers',                         44.8428, -0.5530, 1),
        (14, 'Cours de l''Yser',             'Cours de l''Yser',                      44.8250, -0.5675, 1),
        (15, 'Mériadeck - Georges Bonnac',   'Rue Georges Bonnac',                    44.8392, -0.5865, 1),
        (16, 'Peixotto - Campus',            'Cours de la Libération',                44.8075, -0.5889, 2),
        (17, 'Barrière de Pessac - Gallieni','Cours Maréchal Gallieni',               44.8218, -0.5945, 2),
        (18, 'Thouars - Lycée',              'Avenue de Thouars',                     44.7972, -0.5795, 2),
        (19, 'Pessac Centre - Jean Jaurès',  'Avenue Jean Jaurès',                    44.8067, -0.6311, 3),
        (20, 'Mérignac - Avenue de l''Yser', 'Avenue de l''Yser',                     44.8386, -0.6459, 4),
        (21, 'Bègles - Ambroise Croizat',    'Rue Ambroise Croizat',                  44.8085, -0.5495, 5),
        (22, 'Le Bouscat - Libération',      'Avenue de la Libération Charles de Gaulle', 44.8625, -0.5955, 6),
        (23, 'Cenon - Jean Zay Goya',        'Avenue Jean Zay',                       44.8565, -0.5315, 7),
        (24, 'Floirac - Jules Guesde',       'Rue Jules Guesde',                      44.8365, -0.5250, 8),
        (25, 'Gradignan - Général de Gaulle','Cours du Général de Gaulle',            44.7725, -0.6155, 9)
    ) AS t(idx, nom, axe, lat, lon, id_commune)
    WHERE t.idx = 1 + ((i - 1) % 25)
) AS base;

-- Répartition fine des dernières stations sur Villenave-d'Ornon, Bruges et Lormont (2e couronne)
UPDATE station SET id_commune = 10 WHERE id_station IN (185, 186, 187, 188, 189);
UPDATE station SET id_commune = 11 WHERE id_station IN (190, 191, 192, 193, 194, 195);
UPDATE station SET id_commune = 12 WHERE id_station IN (196, 197, 198, 199, 200);


-- Distances entre stations proches (formule de Haversine)
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
WHERE (s2.id_station - s1.id_station) <= 4;


-- 600 vélos électriques "Le Vélo par TBM"
--    (+500 vélos déployés en 2025, 67 % VAE standard, 23 % Cargo VAE, 10 % Compact/Pro)
--    Les vélos V0596 à V0600 restent neufs et jamais empruntés.
INSERT INTO velo (reference, date_mise_service, kilometrage, etat, niveau_batterie, id_modele, id_station)
SELECT
    'V' || lpad(i::text, 4, '0'),
    -- Forte proportion de vélos mis en service en 2025-2026 (renouvellement flotte TBM)
    CASE
        WHEN i > 595         THEN CURRENT_DATE - (floor(random() * 20)::int)
        WHEN random() < 0.75 THEN CURRENT_DATE - (floor(random() * 365)::int)
        ELSE                      CURRENT_DATE - (365 + floor(random() * 500)::int)
    END,
    CASE WHEN i > 595 THEN 0.0 ELSE ROUND((200 + random() * 4200)::numeric, 1) END,
    etat_velo,
    CASE
        WHEN etat_velo = 'hors_service' THEN 0
        WHEN random() < 0.10 THEN floor(random() * 20)::int
        ELSE 35 + floor(random() * 66)::int
    END,
    CASE
        WHEN (i % 10) IN (0, 1, 2, 3, 4, 5) THEN 1   -- 60 % Le Vélo Électrique 2.0
        WHEN (i % 10) IN (6, 7)             THEN 2   -- 20 % Le Vélo Cargo VAE
        WHEN (i % 10) = 8                   THEN 3   -- 10 % Le Vélo Compact Pliant
        ELSE                                     4   -- 10 % UrbanGlide VAE Pro
    END,
    CASE
        WHEN etat_velo = 'disponible' THEN 1 + ((i - 1) % 200)
        ELSE NULL
    END
FROM (
    SELECT
        i,
        CASE
            WHEN i BETWEEN 581 AND 595 THEN 'en_utilisation'
            WHEN i > 595               THEN 'disponible'
            WHEN random() < 0.06       THEN 'maintenance'
            WHEN random() < 0.02       THEN 'hors_service'
            ELSE 'disponible'
        END AS etat_velo
    FROM generate_series(1, 600) AS i
) sub;


--  1 500 adhérents inscrits sur Bordeaux Métropole
--    Distribution conforme à l'Observatoire 2025 :
--    40 % Bordeaux (1), 41 % 1re couronne (2..8), 19 % 2e couronne (9..12)
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
        'cours Victor Hugo', 'quai Louis XVIII', 'cours de l''Argonne',
        'allées de Tourny', 'cours Maréchal Gallieni', 'avenue Jean Jaurès',
        'avenue Thiers', 'rue Sainte-Catherine', 'quai de Bacalan', 'boulevard Albert 1er'
    ])[1 + (i % 10)],
    'adherent' || i || '@tbm-levelo.fr',
    '06' || lpad(i::text, 8, '0'),
    CURRENT_DATE - (floor(random() * 450)::int),
    CASE
        WHEN (i % 100) < 40 THEN 1                            -- 40 % Bordeaux
        WHEN (i % 100) < 81 THEN 2 + (i % 7)                  -- 41 % 1re couronne (communes 2 à 8)
        ELSE                     9 + (i % 4)                  -- 19 % 2e couronne (communes 9 à 12)
    END
FROM generate_series(1, 1500) AS i;


-- 20 000 emprunts historiques calibrés sur les statistiques TBM 2025 :
--    * Trajet moyen Observatoire 2025 : ~12 minutes et ~2,7 km
--      (durée tirée entre 5 et 20 min, moyenne ~12,5 min ; vitesse ~0,216 km/min -> ~2,7 km)
--    * Heures de pointe domicile-travail/études (enquêtes 7h15-9h15 et 16h30-18h30)
--    * Forte concentration des départs sur Bordeaux intra-boulevards (stations 1..15 et multiples)
INSERT INTO emprunt (id_adherent, reference, id_station_depart, id_station_arrivee,
                     date_heure_depart, date_heure_arrivee, distance_parcourue)
SELECT
    1 + floor(random() * 1480)::int,
    'V' || lpad((1 + floor(random() * 580)::int)::text, 4, '0'),
    station_dep,
    station_arr,
    ts,
    ts + (duration_min || ' minutes')::interval,
    ROUND((duration_min * (0.18 + random() * 0.072))::numeric, 2)  -- moyenne ~2,7 km pour 12,5 min
FROM (
    SELECT
        -- 60 % des trajets partent des stations très fréquentées (Pont de Pierre, Quinconces, Victoire, Bacalan...)
        CASE
            WHEN random() < 0.60 THEN 1 + floor(random() * 50)::int
            ELSE                      1 + floor(random() * 200)::int
        END AS station_dep,
        CASE
            WHEN random() < 0.60 THEN 1 + floor(random() * 50)::int
            ELSE                      1 + floor(random() * 200)::int
        END AS station_arr,
        (CURRENT_DATE - (1 + floor(random() * 90)::int))
            + (CASE
                WHEN random() < 0.42 THEN 7  + floor(random() * 3)::int   -- Pointe matin enquête TBM (7h-9h)
                WHEN random() < 0.84 THEN 16 + floor(random() * 3)::int   -- Pointe soir enquête TBM (16h-18h)
                ELSE                      10 + floor(random() * 6)::int   -- Heures creuses (10h-15h)
               END || ' hours')::interval
            + (floor(random() * 60)::int || ' minutes')::interval AS ts,
        5 + floor(random() * 16)::int AS duration_min                      -- 5 à 20 min (moyenne ~12,5 min)
    FROM generate_series(1, 20000)
) sub;

-- 15 emprunts actuellement en cours (vélos V0581 à V0595)
INSERT INTO emprunt (id_adherent, reference, id_station_depart, id_station_arrivee,
                     date_heure_depart, date_heure_arrivee, distance_parcourue)
SELECT
    1480 + i,
    'V' || lpad((580 + i)::text, 4, '0'),
    1 + (i % 25),
    NULL,
    CURRENT_TIMESTAMP - ((4 + i) || ' minutes')::interval,
    NULL,
    NULL
FROM generate_series(1, 15) AS i;


--  350 interventions de maintenance sur l'année écoulée
INSERT INTO intervention (reference, date_intervention, nature, duree_heures)
SELECT
    'V' || lpad((1 + floor(random() * 580)::int)::text, 4, '0'),
    CURRENT_DATE - (floor(random() * 365)::int),
    (ARRAY[
        'Révision périodique TBM Cykleo',
        'Remplacement batterie VAE 36V',
        'Crevaison pneu renforcé',
        'Réglage freins hydrauliques',
        'Changement de chaîne et transmission',
        'Mise à jour capteur couple assistance électrique',
        'Réparation borne de verrouillage cadre',
        'Remplacement éclairage LED avant/arrière'
    ])[1 + (i % 8)],
    ROUND((0.5 + floor(random() * 10) * 0.5)::numeric, 2)
FROM generate_series(1, 350) AS i;

-- Garantit que chaque vélo actuellement en maintenance possède une intervention récente
INSERT INTO intervention (reference, date_intervention, nature, duree_heures)
SELECT
    reference,
    CURRENT_DATE - (floor(random() * 5)::int),
    'Maintenance préventive flotte Le Vélo par TBM',
    2.0
FROM velo
WHERE etat = 'maintenance';

COMMIT;
