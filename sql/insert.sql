BEGIN;

INSERT INTO commune (nom_commune, code_postal) VALUES
    ('Bordeaux',           '33000'),
    ('Talence',            '33400'),
    ('Pessac',             '33600'),
    ('Mérignac',           '33700'),
    ('Bègles',             '33130'),
    ('Le Bouscat',         '33110'),
    ('Cenon',              '33150'),
    ('Floirac',            '33270'),
    ('Gradignan',          '33170'),
    ('Villenave-d''Ornon', '33140'),
    ('Bruges',             '33520'),
    ('Lormont',            '33310');

INSERT INTO modele (nom_modele, marque) VALUES
    ('Vélo Électrique 2.0', 'Cykleo'),
    ('Vélo Cargo VAE',      'Babboe'),
    ('Vélo Compact Pliant', 'Brompton'),
    ('UrbanGlide VAE Pro',  'Pony');

INSERT INTO station (nom_station, adresse_station, latitude, longitude, nb_bornes, id_commune) VALUES
    ('Pont de Pierre',   '1 Place Stalingrad',            44.838900, -0.562200, 24, 1),
    ('Quinconces',       '8 Quai Louis XVIII',            44.845200, -0.570500, 32, 1),
    ('Victoire',         '3 Cours de la Somme',           44.830600, -0.572800, 28, 1),
    ('Gare Saint-Jean',  '28 Rue Charles Domercq',        44.825800, -0.556200, 32, 1),
    ('Bacalan',          '22 Quai de Bacalan',            44.858200, -0.553500, 16, 1),
    ('Tourny',           '12 Allées de Tourny',           44.843500, -0.577200, 24, 1),
    ('Mériadeck',        '17 Rue Georges Bonnac',         44.839200, -0.586500, 24, 1),
    ('Victor Hugo',      '15 Cours Victor Hugo',          44.835100, -0.571400, 20, 1),
    ('Gallieni',         '65 Cours Maréchal Gallieni',    44.821800, -0.594500, 24, 2),
    ('Campus',           '40 Cours de la Libération',     44.807500, -0.588900, 28, 2),
    ('Thouars',          '11 Avenue de Thouars',          44.797200, -0.579500, 16, 2),
    ('Pessac Centre',    '21 Avenue Jean Jaurès',         44.806700, -0.631100, 20, 3),
    ('Pessac Alouette',  '4 Avenue de l''Alouette',       44.793500, -0.652000, 16, 3),
    ('Mérignac Yser',    '5 Avenue de l''Yser',           44.838600, -0.645900, 20, 4),
    ('Bègles Croizat',   '14 Rue Ambroise Croizat',       44.808500, -0.549500, 16, 5),
    ('Le Bouscat',       '30 Avenue de la Libération',    44.862500, -0.595500, 16, 6),
    ('Cenon Jean Zay',   '8 Avenue Jean Zay',             44.856500, -0.531500, 16, 7),
    ('Floirac Guesde',   '19 Rue Jules Guesde',           44.836500, -0.525000, 16, 8),
    ('Gradignan Centre', '6 Cours du Général de Gaulle',  44.772500, -0.615500,  4, 9),
    ('Villenave Maye',   '2 Route de Toulouse',           44.772800, -0.561700, 16, 10);

INSERT INTO distance (station_a, station_b, distance_km) VALUES
    ( 1,  2, 1.80),
    ( 1,  3, 2.90),
    ( 1,  4, 3.10),
    ( 1,  5, 3.50),
    ( 1,  6, 2.20),
    ( 1, 17, 4.50),
    ( 1, 18, 5.20),
    ( 2,  3, 2.60),
    ( 2,  4, 3.80),
    ( 2,  5, 2.40),
    ( 2,  6, 1.10),
    ( 2,  7, 1.90),
    ( 2, 16, 4.30),
    ( 3,  4, 2.50),
    ( 3,  7, 1.70),
    ( 3,  8, 1.40),
    ( 3,  9, 4.60),
    ( 4,  8, 2.30),
    ( 4, 15, 4.20),
    ( 5,  6, 3.00),
    ( 6,  7, 1.60),
    ( 6,  8, 2.00),
    ( 7,  8, 1.20),
    ( 9, 10, 1.20),
    ( 9, 11, 3.30),
    ( 9, 12, 7.50),
    ( 9, 19, 6.30),
    (10, 11, 3.00),
    (10, 12, 6.90),
    (11, 19, 4.00),
    (12, 13, 2.10),
    (12, 14, 6.80),
    (15, 20, 6.10);

INSERT INTO velo (reference, date_mise_service, kilometrage, etat, niveau_batterie, id_modele, id_station) VALUES
    ('V0001', CURRENT_DATE - 400, 1200.0, 'disponible',     90, 1,  2),
    ('V0002', CURRENT_DATE - 380,  900.5, 'disponible',     80, 1,  9),
    ('V0003', CURRENT_DATE - 300,  650.0, 'disponible',     30, 1,  4),
    ('V0004', CURRENT_DATE - 350, 1100.0, 'disponible',     95, 1,  4),
    ('V0005', CURRENT_DATE - 200,  400.0, 'disponible',     60, 2,  2),
    ('V0006', CURRENT_DATE - 250,  780.0, 'disponible',     70, 2,  3),
    ('V0007', CURRENT_DATE - 150,  300.0, 'disponible',     40, 3,  9),
    ('V0008', CURRENT_DATE - 520,  520.0, 'disponible',     85, 4, 12),
    ('V0009', CURRENT_DATE - 100,  210.0, 'disponible',     55, 1,  9),
    ('V0010', CURRENT_DATE - 90,   150.0, 'disponible',     20, 1,  9),
    ('V0011', CURRENT_DATE - 130,  260.0, 'disponible',     88, 1, 16),
    ('V0012', CURRENT_DATE - 140,  310.0, 'disponible',     50, 2, 15),
    ('V0013', CURRENT_DATE - 110,  230.0, 'disponible',     65, 1, 10),
    ('V0014', CURRENT_DATE - 120,  280.0, 'disponible',     70, 1,  1),
    ('V0015', CURRENT_DATE - 80,   190.0, 'disponible',     45, 3,  4),
    ('V0016', CURRENT_DATE - 70,   170.0, 'disponible',     75, 4,  5),
    ('V0017', CURRENT_DATE - 360,  840.0, 'disponible',     90, 1,  7),
    ('V0018', CURRENT_DATE - 340,  760.0, 'disponible',     80, 1,  8),
    ('V0019', CURRENT_DATE - 320,  690.0, 'disponible',     62, 2,  3),
    ('V0020', CURRENT_DATE - 310,  610.0, 'disponible',     58, 1,  8),
    ('V0021', CURRENT_DATE - 290,  570.0, 'disponible',    100, 1, 17),
    ('V0022', CURRENT_DATE - 270,  530.0, 'disponible',     77, 3, 18),
    ('V0023', CURRENT_DATE - 260,  490.0, 'disponible',     66, 1, 19),
    ('V0024', CURRENT_DATE - 240,  450.0, 'disponible',     35, 2, 19),
    ('V0025', CURRENT_DATE - 230,  410.0, 'disponible',     82, 1, 13),
    ('V0026', CURRENT_DATE - 210,  380.0, 'disponible',     57, 4, 14),
    ('V0027', CURRENT_DATE - 190,  340.0, 'disponible',     92, 1, 20),
    ('V0028', CURRENT_DATE - 170,  300.0, 'disponible',     83, 1,  2),
    ('V0029', CURRENT_DATE - 150,  270.0, 'disponible',     72, 2,  7),
    ('V0030', CURRENT_DATE - 130,  240.0, 'disponible',     48, 1,  6),
    -- V0031 à V0034 : insérés 'disponible' dans leur station de départ ; l'insertion de leur
    -- emprunt en cours (plus bas) les passe en 'en_utilisation' via le trigger
    ('V0031', CURRENT_DATE - 180,  480.0, 'disponible',     65, 1,  1),
    ('V0032', CURRENT_DATE - 170,  450.0, 'disponible',     55, 1,  1),
    ('V0033', CURRENT_DATE - 160,  350.0, 'disponible',     50, 2,  2),
    ('V0034', CURRENT_DATE - 150,  320.0, 'disponible',     72, 4,  3),
    ('V0035', CURRENT_DATE - 500, 2500.0, 'maintenance',    15, 1, NULL),
    ('V0036', CURRENT_DATE - 450, 2100.0, 'maintenance',     0, 4, NULL),
    ('V0037', CURRENT_DATE - 430, 1900.0, 'maintenance',    25, 2, NULL),
    ('V0038', CURRENT_DATE - 600, 3000.0, 'hors_service',    0, 1, NULL),
    ('V0039', CURRENT_DATE - 5,      0.0, 'disponible',    100, 1, 14),
    ('V0040', CURRENT_DATE - 5,      0.0, 'disponible',    100, 2, 20),
    -- V0041/V0042 : avec V0023 et V0024, la station 19 (4 bornes) est pleine (places_libres = 0)
    ('V0041', CURRENT_DATE - 3,      0.0, 'disponible',     90, 1, 19),
    ('V0042', CURRENT_DATE - 3,      0.0, 'disponible',     85, 3, 19);

INSERT INTO adherent (nom, prenom, adresse, email, telephone, date_adhesion, id_commune) VALUES
    ('Martin',   'Léa',      '12 cours Victor Hugo',        'lea.martin@mail.fr',       '0600000001', CURRENT_DATE - 300, 1),
    ('Durand',   'Hugo',     '5 avenue Thiers',             'hugo.durand@mail.fr',      '0600000002', CURRENT_DATE - 290, 2),
    ('Petit',    'Inès',     '8 avenue Jean Jaurès',        'ines.petit@mail.fr',       '0600000003', CURRENT_DATE - 280, 3),
    ('Roux',     'Lucas',    '3 avenue de l''Yser',         'lucas.roux@mail.fr',       '0600000004', CURRENT_DATE - 270, 4),
    ('Simon',    'Chloé',    '20 quai de Bacalan',          'chloe.simon@mail.fr',      '0600000005', CURRENT_DATE - 260, 1),
    ('Moreau',   'Nathan',   '7 allées de Tourny',          'nathan.moreau@mail.fr',    '0600000006', CURRENT_DATE - 250, 1),
    ('Leroy',    'Manon',    '14 cours Gallieni',           'manon.leroy@mail.fr',      '0600000007', CURRENT_DATE - 240, 2),
    ('Garcia',   'Yanis',    '9 rue Sainte-Catherine',      'yanis.garcia@mail.fr',     '0600000008', CURRENT_DATE - 230, 3),
    ('Bernard',  'Emma',     '2 rue Ambroise Croizat',      'emma.bernard@mail.fr',     '0600000009', CURRENT_DATE - 220, 5),
    ('Dubois',   'Louis',    '18 avenue de la Libération',  'louis.dubois@mail.fr',     '0600000010', CURRENT_DATE - 210, 6),
    ('Thomas',   'Jade',     '6 avenue Jean Zay',           'jade.thomas@mail.fr',      '0600000011', CURRENT_DATE - 200, 7),
    ('Robert',   'Arthur',   '4 rue Jules Guesde',          'arthur.robert@mail.fr',    '0600000012', CURRENT_DATE - 190, 8),
    ('Richard',  'Alice',    '25 cours de l''Argonne',      'alice.richard@mail.fr',    '0600000013', CURRENT_DATE - 180, 1),
    ('Michel',   'Jules',    '10 quai Louis XVIII',         'jules.michel@mail.fr',     '0600000014', CURRENT_DATE - 170, 1),
    ('Laurent',  'Sarah',    '33 cours Gallieni',           'sarah.laurent@mail.fr',    '0600000015', CURRENT_DATE - 160, 2),
    ('Lefebvre', 'Adam',     '7 cours du Général de Gaulle','adam.lefebvre@mail.fr',    '0600000016', CURRENT_DATE - 150, 9),
    ('David',    'Lina',     '15 route de Toulouse',        'lina.david@mail.fr',       '0600000017', CURRENT_DATE - 140, 10),
    ('Bertrand', 'Noah',     '3 avenue du Général Leclerc', 'noah.bertrand@mail.fr',    '0600000018', CURRENT_DATE - 130, 11),
    ('Vincent',  'Camille',  '12 avenue Carnot',            'camille.vincent@mail.fr',  '0600000019', CURRENT_DATE - 120, 12),
    ('Fournier', 'Gabriel',  '40 boulevard Albert 1er',     'gabriel.fournier@mail.fr', '0600000020', CURRENT_DATE - 110, 1),
    ('Girard',   'Zoé',      '6 avenue de l''Yser',         'zoe.girard@mail.fr',       '0600000021', CURRENT_DATE - 100, 4),
    ('Andre',    'Tom',      '22 avenue Jean Jaurès',       'tom.andre@mail.fr',        '0600000022', CURRENT_DATE - 90,  3),
    ('Lambert',  'Eva',      '9 cours Victor Hugo',         'eva.lambert@mail.fr',      '0600000023', CURRENT_DATE - 80,  1),
    ('Mercier',  'Paul',     '18 cours Gallieni',           'paul.mercier@mail.fr',     '0600000024', CURRENT_DATE - 70,  2),
    ('Fontaine', 'Rose',     '5 rue Sainte-Catherine',      'rose.fontaine@mail.fr',    '0600000025', CURRENT_DATE - 60,  1),
    -- adhésions expirées / limites, et adhérents sans aucun emprunt
    ('Blanc',    'Théo',     '11 rue du Palais Gallien',    'theo.blanc@mail.fr',       '0600000026', CURRENT_DATE - 400, 1),  -- expirée, a des emprunts anciens
    ('Chevalier','Maël',     '4 rue de la Course',          'mael.chevalier@mail.fr',   '0600000027', CURRENT_DATE - 366, 2),  -- expirée depuis hier, sans emprunt
    ('Perrin',   'Clara',    '9 avenue Thiers',             'clara.perrin@mail.fr',     '0600000028', CURRENT_DATE - 365, 6),  -- dernier jour de validité, sans emprunt
    ('Colin',    'Enzo',     '16 rue Sainte-Catherine',     'enzo.colin@mail.fr',       '0600000029', CURRENT_DATE - 5,   1);  -- récent, sans emprunt

INSERT INTO emprunt (id_adherent, reference, id_station_depart, id_station_arrivee,
                     date_heure_depart, date_heure_arrivee, distance_parcourue) VALUES
    ( 2, 'V0001',  1,  2, (CURRENT_DATE - 1)  + TIME '07:50', (CURRENT_DATE - 1)  + TIME '08:02', 1.80),
    ( 1, 'V0001',  3,  1, (CURRENT_DATE - 2)  + TIME '08:00', (CURRENT_DATE - 2)  + TIME '08:11', 2.90),
    ( 3, 'V0001',  1,  3, (CURRENT_DATE - 4)  + TIME '17:10', (CURRENT_DATE - 4)  + TIME '17:25', 2.90),
    ( 4, 'V0001',  5,  1, (CURRENT_DATE - 6)  + TIME '08:20', (CURRENT_DATE - 6)  + TIME '08:35', 3.50),
    ( 5, 'V0001',  1,  5, (CURRENT_DATE - 8)  + TIME '12:00', (CURRENT_DATE - 8)  + TIME '12:18', 3.50),
    ( 6, 'V0001',  4,  1, (CURRENT_DATE - 10) + TIME '18:00', (CURRENT_DATE - 10) + TIME '18:20', 3.10),
    ( 7, 'V0001',  1,  4, (CURRENT_DATE - 12) + TIME '09:00', (CURRENT_DATE - 12) + TIME '09:20', 3.10),
    ( 8, 'V0001',  2,  1, (CURRENT_DATE - 15) + TIME '17:00', (CURRENT_DATE - 15) + TIME '17:20', 1.80),
    ( 2, 'V0001',  1,  2, (CURRENT_DATE - 17) + TIME '08:05', (CURRENT_DATE - 17) + TIME '08:17', 1.80),
    ( 3, 'V0001',  6,  1, (CURRENT_DATE - 20) + TIME '16:45', (CURRENT_DATE - 20) + TIME '16:57', 2.20),
    (13, 'V0001',  1,  6, (CURRENT_DATE - 23) + TIME '12:10', (CURRENT_DATE - 23) + TIME '12:25', 2.20),
    (14, 'V0001',  3,  1, (CURRENT_DATE - 27) + TIME '18:30', (CURRENT_DATE - 27) + TIME '18:45', 2.90),
    ( 2, 'V0001',  1,  3, (CURRENT_DATE - 45) + TIME '08:00', (CURRENT_DATE - 45) + TIME '08:15', 2.90),
    -- trajets à dates fixes (année 2026) : frequentation_stations(mois) renvoie des données pour plusieurs mois
    ( 1, 'V0001',  1,  2, TIMESTAMP '2026-03-10 08:00', TIMESTAMP '2026-03-10 08:12', 1.80),
    ( 1, 'V0001',  2,  1, TIMESTAMP '2026-03-10 18:00', TIMESTAMP '2026-03-10 18:12', 1.80),
    ( 2, 'V0001',  1,  2, TIMESTAMP '2026-06-15 08:00', TIMESTAMP '2026-06-15 08:12', 1.80),
    ( 2, 'V0001',  2,  1, TIMESTAMP '2026-06-15 18:00', TIMESTAMP '2026-06-15 18:12', 1.80),
    ( 3, 'V0001',  1,  2, TIMESTAMP '2026-09-05 08:00', TIMESTAMP '2026-09-05 08:12', 1.80),
    ( 3, 'V0001',  2,  1, TIMESTAMP '2026-09-05 18:00', TIMESTAMP '2026-09-05 18:12', 1.80),

    (15, 'V0002', 10,  9, (CURRENT_DATE - 1)  + TIME '18:00', (CURRENT_DATE - 1)  + TIME '18:11', 1.20),
    ( 2, 'V0002',  9, 10, (CURRENT_DATE - 2)  + TIME '08:30', (CURRENT_DATE - 2)  + TIME '08:41', 1.20),
    (24, 'V0002', 11,  9, (CURRENT_DATE - 4)  + TIME '12:00', (CURRENT_DATE - 4)  + TIME '12:20', 3.30),
    (15, 'V0002',  9, 11, (CURRENT_DATE - 5)  + TIME '17:30', (CURRENT_DATE - 5)  + TIME '17:50', 3.30),
    ( 8, 'V0002', 10,  9, (CURRENT_DATE - 7)  + TIME '09:15', (CURRENT_DATE - 7)  + TIME '09:26', 1.20),
    ( 7, 'V0002',  9, 10, (CURRENT_DATE - 9)  + TIME '17:45', (CURRENT_DATE - 9)  + TIME '17:56', 1.20),
    (22, 'V0002', 12,  9, (CURRENT_DATE - 11) + TIME '10:00', (CURRENT_DATE - 11) + TIME '10:30', 7.50),
    ( 8, 'V0002', 10, 12, (CURRENT_DATE - 13) + TIME '16:00', (CURRENT_DATE - 13) + TIME '16:30', 6.90),
    (24, 'V0002',  9, 10, (CURRENT_DATE - 16) + TIME '08:10', (CURRENT_DATE - 16) + TIME '08:21', 1.20),
    ( 2, 'V0002', 11,  9, (CURRENT_DATE - 19) + TIME '18:10', (CURRENT_DATE - 19) + TIME '18:30', 3.30),
    (15, 'V0002',  9, 11, (CURRENT_DATE - 45) + TIME '08:00', (CURRENT_DATE - 45) + TIME '08:20', 3.30),

    ( 4, 'V0003',  4,  3, (CURRENT_DATE - 21) + TIME '08:00', (CURRENT_DATE - 21) + TIME '08:15', 2.50),
    (24, 'V0003',  3,  4, (CURRENT_DATE - 4)  + TIME '17:00', (CURRENT_DATE - 4)  + TIME '17:15', 2.50),

    ( 5, 'V0004',  4,  3, (CURRENT_DATE - 5)  + TIME '08:30', (CURRENT_DATE - 5)  + TIME '08:45', 2.50),
    ( 1, 'V0004',  3,  4, (CURRENT_DATE - 2)  + TIME '17:30', (CURRENT_DATE - 2)  + TIME '17:42', 2.50),
    ( 5, 'V0004',  3,  4, (CURRENT_DATE - 50) + TIME '17:00', (CURRENT_DATE - 50) + TIME '17:12', 2.50),

    ( 2, 'V0005',  3,  2, (CURRENT_DATE - 7)  + TIME '08:10', (CURRENT_DATE - 7)  + TIME '08:22', 2.60),
    (23, 'V0005',  2,  3, (CURRENT_DATE - 9)  + TIME '17:40', (CURRENT_DATE - 9)  + TIME '17:52', 2.60),

    ( 4, 'V0006',  4,  3, (CURRENT_DATE - 11) + TIME '08:00', (CURRENT_DATE - 11) + TIME '08:14', 2.50),
    ( 6, 'V0006',  3,  4, (CURRENT_DATE - 14) + TIME '17:20', (CURRENT_DATE - 14) + TIME '17:35', 2.50),

    ( 3, 'V0007',  3,  9, (CURRENT_DATE - 18) + TIME '10:00', (CURRENT_DATE - 18) + TIME '10:40', 4.60),
    ( 3, 'V0007',  8,  3, (CURRENT_DATE - 29) + TIME '09:00', (CURRENT_DATE - 29) + TIME '09:10', 1.40),

    ( 7, 'V0008',  9, 12, (CURRENT_DATE - 6)  + TIME '10:00', (CURRENT_DATE - 6)  + TIME '10:30', 7.50),
    ( 7, 'V0008', 12,  9, (CURRENT_DATE - 21) + TIME '08:00', (CURRENT_DATE - 21) + TIME '08:30', 7.50),

    ( 1, 'V0009', 10,  9, (CURRENT_DATE - 13) + TIME '15:00', (CURRENT_DATE - 13) + TIME '15:10', 1.20),
    ( 1, 'V0009',  9, 10, (CURRENT_DATE - 24) + TIME '15:00', (CURRENT_DATE - 24) + TIME '15:10', 1.20),

    ( 8, 'V0010', 12,  9, (CURRENT_DATE - 16) + TIME '08:00', (CURRENT_DATE - 16) + TIME '08:25', 7.50),
    ( 8, 'V0010',  9, 12, (CURRENT_DATE - 27) + TIME '08:00', (CURRENT_DATE - 27) + TIME '08:30', 7.50),

    ( 9, 'V0011',  2, 16, (CURRENT_DATE - 4)  + TIME '09:30', (CURRENT_DATE - 4)  + TIME '09:50', 4.30),
    ( 9, 'V0011', 16,  2, (CURRENT_DATE - 14) + TIME '17:30', (CURRENT_DATE - 14) + TIME '17:50', 4.30),

    (10, 'V0012',  4, 15, (CURRENT_DATE - 9)  + TIME '14:00', (CURRENT_DATE - 9)  + TIME '14:25', 4.20),
    (10, 'V0012', 15,  4, (CURRENT_DATE - 20) + TIME '14:00', (CURRENT_DATE - 20) + TIME '14:25', 4.20),
    ( 9, 'V0012', 15,  4, (CURRENT_DATE - 4)  + TIME '16:00', (CURRENT_DATE - 4)  + TIME '16:25', 4.20),
    ( 9, 'V0012',  4, 15, (CURRENT_DATE - 4)  + TIME '18:00', (CURRENT_DATE - 4)  + TIME '18:25', 4.20),

    (11, 'V0013', 10, 11, (CURRENT_DATE - 3)  + TIME '08:00', (CURRENT_DATE - 3)  + TIME '08:15', 3.00),
    (11, 'V0013', 11, 10, (CURRENT_DATE - 3)  + TIME '17:00', (CURRENT_DATE - 3)  + TIME '17:15', 3.00),
    (15, 'V0013', 11, 10, (CURRENT_DATE - 10) + TIME '12:00', (CURRENT_DATE - 10) + TIME '12:15', 3.00),

    (12, 'V0014',  1,  5, (CURRENT_DATE - 19) + TIME '08:00', (CURRENT_DATE - 19) + TIME '08:20', 3.50),
    (12, 'V0014',  5,  1, (CURRENT_DATE - 2)  + TIME '10:00', (CURRENT_DATE - 2)  + TIME '10:20', 3.50),

    ( 9, 'V0015',  4,  3, (CURRENT_DATE - 17) + TIME '16:30', (CURRENT_DATE - 17) + TIME '16:45', 2.50),
    ( 9, 'V0015',  3,  4, (CURRENT_DATE - 8)  + TIME '16:30', (CURRENT_DATE - 8)  + TIME '16:45', 2.50),
    ( 9, 'V0015',  4,  8, (CURRENT_DATE - 4)  + TIME '13:00', (CURRENT_DATE - 4)  + TIME '13:12', 2.30),
    ( 9, 'V0015',  8,  4, (CURRENT_DATE - 4)  + TIME '13:30', (CURRENT_DATE - 4)  + TIME '13:42', 2.30),

    (10, 'V0016',  5,  2, (CURRENT_DATE - 25) + TIME '17:00', (CURRENT_DATE - 25) + TIME '17:15', 2.40),
    (10, 'V0016',  2,  5, (CURRENT_DATE - 12) + TIME '11:00', (CURRENT_DATE - 12) + TIME '11:15', 2.40),

    (13, 'V0017',  7,  6, (CURRENT_DATE - 40) + TIME '08:00', (CURRENT_DATE - 40) + TIME '08:10', 1.60),
    (13, 'V0017',  6,  7, (CURRENT_DATE - 1)  + TIME '08:20', (CURRENT_DATE - 1)  + TIME '08:30', 1.60),

    (14, 'V0018',  8,  7, (CURRENT_DATE - 10) + TIME '12:30', (CURRENT_DATE - 10) + TIME '12:40', 1.20),
    (14, 'V0018',  7,  8, (CURRENT_DATE - 2)  + TIME '12:30', (CURRENT_DATE - 2)  + TIME '12:40', 1.20),

    (20, 'V0019',  3,  8, (CURRENT_DATE - 12) + TIME '08:30', (CURRENT_DATE - 12) + TIME '08:40', 1.40),
    (20, 'V0019',  8,  3, (CURRENT_DATE - 3)  + TIME '18:00', (CURRENT_DATE - 3)  + TIME '18:10', 1.40),
    (12, 'V0019',  3,  8, (CURRENT_DATE - 2)  + TIME '15:00', (CURRENT_DATE - 2)  + TIME '15:10', 1.40),
    (12, 'V0019',  8,  3, (CURRENT_DATE - 2)  + TIME '16:00', (CURRENT_DATE - 2)  + TIME '16:10', 1.40),

    (23, 'V0020',  8,  3, (CURRENT_DATE - 15) + TIME '09:00', (CURRENT_DATE - 15) + TIME '09:10', 1.40),
    (23, 'V0020',  3,  8, (CURRENT_DATE - 5)  + TIME '09:00', (CURRENT_DATE - 5)  + TIME '09:10', 1.40),

    ( 2, 'V0021', 17,  1, (CURRENT_DATE - 33) + TIME '08:00', (CURRENT_DATE - 33) + TIME '08:25', 4.50),
    -- 10 trajets supplémentaires sur 30 jours : V0021 totalise 11 trajets (retenu par utilisation_velos)
    (20, 'V0021',  1,  3, (CURRENT_DATE - 21) + TIME '08:00', (CURRENT_DATE - 21) + TIME '08:15', 2.90),
    (20, 'V0021',  3,  1, (CURRENT_DATE - 21) + TIME '18:00', (CURRENT_DATE - 21) + TIME '18:15', 2.90),
    (21, 'V0021',  1,  3, (CURRENT_DATE - 19) + TIME '08:00', (CURRENT_DATE - 19) + TIME '08:15', 2.90),
    (21, 'V0021',  3,  1, (CURRENT_DATE - 19) + TIME '18:00', (CURRENT_DATE - 19) + TIME '18:15', 2.90),
    (25, 'V0021',  1,  3, (CURRENT_DATE - 16) + TIME '08:00', (CURRENT_DATE - 16) + TIME '08:15', 2.90),
    (25, 'V0021',  3,  1, (CURRENT_DATE - 16) + TIME '18:00', (CURRENT_DATE - 16) + TIME '18:15', 2.90),
    (24, 'V0021',  1,  3, (CURRENT_DATE - 12) + TIME '08:00', (CURRENT_DATE - 12) + TIME '08:15', 2.90),
    (24, 'V0021',  3,  1, (CURRENT_DATE - 12) + TIME '18:00', (CURRENT_DATE - 12) + TIME '18:15', 2.90),
    (22, 'V0021',  1,  3, (CURRENT_DATE - 8)  + TIME '08:00', (CURRENT_DATE - 8)  + TIME '08:15', 2.90),
    (22, 'V0021',  3,  1, (CURRENT_DATE - 8)  + TIME '18:00', (CURRENT_DATE - 8)  + TIME '18:15', 2.90),
    (25, 'V0021',  1, 17, (CURRENT_DATE - 6)  + TIME '17:00', (CURRENT_DATE - 6)  + TIME '17:25', 4.50),

    -- 8 trajets supplémentaires sur 30 jours : V0022 totalise 9 trajets (juste sous le seuil de 10)
    (16, 'V0022',  1,  2, (CURRENT_DATE - 28) + TIME '08:00', (CURRENT_DATE - 28) + TIME '08:12', 1.80),
    (16, 'V0022',  2,  1, (CURRENT_DATE - 28) + TIME '18:00', (CURRENT_DATE - 28) + TIME '18:12', 1.80),
    (17, 'V0022',  1,  2, (CURRENT_DATE - 26) + TIME '08:00', (CURRENT_DATE - 26) + TIME '08:12', 1.80),
    (17, 'V0022',  2,  1, (CURRENT_DATE - 26) + TIME '18:00', (CURRENT_DATE - 26) + TIME '18:12', 1.80),
    (18, 'V0022',  1,  2, (CURRENT_DATE - 24) + TIME '08:00', (CURRENT_DATE - 24) + TIME '08:12', 1.80),
    (18, 'V0022',  2,  1, (CURRENT_DATE - 24) + TIME '18:00', (CURRENT_DATE - 24) + TIME '18:12', 1.80),
    (17, 'V0022',  1,  2, (CURRENT_DATE - 22) + TIME '08:00', (CURRENT_DATE - 22) + TIME '08:12', 1.80),
    (17, 'V0022',  2,  1, (CURRENT_DATE - 22) + TIME '18:00', (CURRENT_DATE - 22) + TIME '18:12', 1.80),
    (17, 'V0022',  1, 18, (CURRENT_DATE - 7)  + TIME '18:00', (CURRENT_DATE - 7)  + TIME '18:25', 5.20),

    (16, 'V0023',  9, 19, (CURRENT_DATE - 8)  + TIME '07:30', (CURRENT_DATE - 8)  + TIME '08:00', 6.30),

    (17, 'V0024', 11, 19, (CURRENT_DATE - 10) + TIME '08:00', (CURRENT_DATE - 10) + TIME '08:20', 4.00),

    (18, 'V0025', 13, 12, (CURRENT_DATE - 15) + TIME '09:00', (CURRENT_DATE - 15) + TIME '09:12', 2.10),
    (18, 'V0025', 12, 13, (CURRENT_DATE - 9)  + TIME '17:00', (CURRENT_DATE - 9)  + TIME '17:12', 2.10),

    (21, 'V0026', 14, 12, (CURRENT_DATE - 22) + TIME '08:00', (CURRENT_DATE - 22) + TIME '08:30', 6.80),
    (21, 'V0026', 12, 14, (CURRENT_DATE - 14) + TIME '08:00', (CURRENT_DATE - 14) + TIME '08:30', 6.80),

    (19, 'V0027', 20, 15, (CURRENT_DATE - 25) + TIME '10:00', (CURRENT_DATE - 25) + TIME '10:30', 6.10),
    (19, 'V0027', 15, 20, (CURRENT_DATE - 15) + TIME '10:00', (CURRENT_DATE - 15) + TIME '10:30', 6.10),

    (22, 'V0028',  6,  2, (CURRENT_DATE - 6)  + TIME '08:40', (CURRENT_DATE - 6)  + TIME '08:48', 1.10),

    (20, 'V0029',  7,  2, (CURRENT_DATE - 18) + TIME '09:00', (CURRENT_DATE - 18) + TIME '09:12', 1.90),
    (20, 'V0029',  2,  7, (CURRENT_DATE - 10) + TIME '09:00', (CURRENT_DATE - 10) + TIME '09:12', 1.90),
    (20, 'V0029',  7,  8, (CURRENT_DATE - 3)  + TIME '08:00', (CURRENT_DATE - 3)  + TIME '08:10', 1.20),
    (20, 'V0029',  8,  7, (CURRENT_DATE - 3)  + TIME '12:00', (CURRENT_DATE - 3)  + TIME '12:10', 1.20),

    (25, 'V0030',  6,  5, (CURRENT_DATE - 20) + TIME '18:00', (CURRENT_DATE - 20) + TIME '18:20', 3.00),
    (25, 'V0030',  5,  6, (CURRENT_DATE - 11) + TIME '18:00', (CURRENT_DATE - 11) + TIME '18:20', 3.00),

    ( 9, 'V0031',  2,  1, (CURRENT_DATE - 9)  + TIME '08:00', (CURRENT_DATE - 9)  + TIME '08:12', 1.80),
    (21, 'V0032',  3,  1, (CURRENT_DATE - 12) + TIME '17:00', (CURRENT_DATE - 12) + TIME '17:15', 2.90),
    (11, 'V0033',  1,  2, (CURRENT_DATE - 8)  + TIME '17:00', (CURRENT_DATE - 8)  + TIME '17:12', 1.80),
    (12, 'V0034',  2,  3, (CURRENT_DATE - 6)  + TIME '08:00', (CURRENT_DATE - 6)  + TIME '08:10', 2.60),

    (26, 'V0035',  1,  4, (CURRENT_DATE - 220) + TIME '08:00', (CURRENT_DATE - 220) + TIME '08:18', 3.10),
    ( 3, 'V0035',  4,  1, (CURRENT_DATE - 35) + TIME '09:00', (CURRENT_DATE - 35) + TIME '09:18', 3.10),
    (10, 'V0036',  2,  3, (CURRENT_DATE - 40) + TIME '09:00', (CURRENT_DATE - 40) + TIME '09:12', 2.60),
    (12, 'V0037',  2,  3, (CURRENT_DATE - 60) + TIME '09:00', (CURRENT_DATE - 60) + TIME '09:12', 2.60);

INSERT INTO emprunt (id_adherent, reference, id_station_depart, id_station_arrivee,
                     date_heure_depart, date_heure_arrivee, distance_parcourue) VALUES
    ( 5, 'V0031', 1, NULL, CURRENT_TIMESTAMP - INTERVAL '20 minutes', NULL, NULL),
    ( 6, 'V0032', 1, NULL, CURRENT_TIMESTAMP - INTERVAL '8 minutes',  NULL, NULL),
    ( 7, 'V0033', 2, NULL, CURRENT_TIMESTAMP - INTERVAL '12 minutes', NULL, NULL),
    (13, 'V0034', 3, NULL, CURRENT_TIMESTAMP - INTERVAL '5 minutes',  NULL, NULL);

INSERT INTO intervention (reference, date_intervention, nature, duree_heures) VALUES
    ('V0035', CURRENT_DATE - 1,   'Remplacement batterie',    3.00),
    ('V0035', CURRENT_DATE - 45,  'Réglage freins',           1.50),
    ('V0035', CURRENT_DATE - 200, 'Crevaison',                0.50),
    ('V0036', CURRENT_DATE - 2,   'Changement de chaîne',     2.00),
    ('V0036', CURRENT_DATE - 100, 'Crevaison',                0.50),
    ('V0037', CURRENT_DATE - 3,   'Révision périodique',      1.50),
    ('V0037', CURRENT_DATE - 150, 'Remplacement éclairage',   0.50),
    ('V0038', CURRENT_DATE - 10,  'Réparation cadre',         4.00),
    ('V0001', CURRENT_DATE - 30,  'Révision périodique',      1.50),
    ('V0001', CURRENT_DATE - 200, 'Remplacement batterie',    2.00),
    ('V0002', CURRENT_DATE - 50,  'Réglage freins',           1.00),
    ('V0003', CURRENT_DATE - 15,  'Crevaison',                0.50),
    ('V0004', CURRENT_DATE - 90,  'Crevaison',                0.50),
    ('V0005', CURRENT_DATE - 60,  'Remplacement batterie',    2.00),
    ('V0006', CURRENT_DATE - 80,  'Réglage freins',           1.00),
    ('V0007', CURRENT_DATE - 110, 'Changement de chaîne',     2.00),
    ('V0008', CURRENT_DATE - 400, 'Révision périodique',      1.00),
    ('V0009', CURRENT_DATE - 50, 'Remplacement éclairage',   0.50),
    ('V0010', CURRENT_DATE - 75,  'Changement de chaîne',     2.00),
    ('V0011', CURRENT_DATE - 40,  'Révision périodique',      1.50),
    ('V0012', CURRENT_DATE - 130, 'Crevaison',                0.50),
    ('V0013', CURRENT_DATE - 25,  'Réglage freins',           1.00),
    ('V0014', CURRENT_DATE - 100, 'Remplacement batterie',    2.00),
    ('V0015', CURRENT_DATE - 70,  'Révision périodique',      1.50),
    ('V0016', CURRENT_DATE - 40, 'Remplacement éclairage',   0.50),
    ('V0017', CURRENT_DATE - 95,  'Changement de chaîne',     2.00),
    ('V0018', CURRENT_DATE - 55,  'Crevaison',                0.50),
    ('V0020', CURRENT_DATE - 140, 'Réglage freins',           1.00),
    ('V0024', CURRENT_DATE - 35,  'Remplacement batterie',    2.00),
    ('V0031', CURRENT_DATE - 20,  'Révision périodique',      1.50),
    ('V0033', CURRENT_DATE - 100, 'Réglage freins',           1.00);

COMMIT;
