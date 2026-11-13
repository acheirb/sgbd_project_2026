

INSERT INTO commune (nom_commune, code_postal) VALUES
    ('Talence',   '33400'),   
    ('Pessac',    '33600'),   
    ('Bordeaux',  '33000'),   
    ('Mérignac',  '33700'),   
    ('Gradignan', '33170');   


INSERT INTO station (nom_station, adresse_station, latitude, longitude, nb_bornes, id_commune) VALUES
    ('Talence Centre',  '1 place Alcala de Henares, Talence', 44.8075, -0.5889, 10, 1),   
    ('Campus Peixotto', 'Avenue de l''Université, Talence',    44.8028, -0.5983, 12, 1),   
    ('Forum',           'Cours de la Libération, Talence',     44.8114, -0.5862,  8, 1),   
    ('Thouars',         'Avenue de Thouars, Talence',          44.7972, -0.5795,  3, 1),   
    ('Pessac Centre',   'Place de la Ve République, Pessac',   44.8067, -0.6311, 10, 2),   
    ('Bersol',          'Avenue de Canteranne, Pessac',        44.7889, -0.6503,  6, 2),   
    ('Alouette',        'Avenue de Beutre, Pessac',            44.7942, -0.6556,  6, 2),   
    ('Victoire',        'Place de la Victoire, Bordeaux',      44.8306, -0.5728, 15, 3),   
    ('Quinconces',      'Esplanade des Quinconces, Bordeaux',  44.8448, -0.5747, 20, 3),   
    ('Mérignac Centre', 'Place Charles de Gaulle, Mérignac',   44.8386, -0.6459,  8, 4);   


INSERT INTO distance (station_a, station_b, distance_km) VALUES
    (1, 2,  1.2),
    (1, 3,  0.8),
    (1, 4,  1.5),
    (1, 5,  3.4),
    (1, 8,  4.1),
    (2, 3,  1.0),
    (2, 4,  1.7),
    (2, 5,  2.6),
    (3, 4,  1.1),
    (5, 6,  1.8),
    (5, 7,  2.2),
    (5, 10, 4.5),
    (8, 9,  1.3);


INSERT INTO modele (nom_modele, marque) VALUES
    ('E-City 500',   'Urbanix'),   
    ('Volt Commute', 'Voltena'),   
    ('Cargo Lite',   'Urbanix'),  
    ('Trek Mob 3',   'Rideon');    


INSERT INTO velo (reference, date_mise_service, kilometrage, etat, niveau_batterie, id_modele, id_station) VALUES
    ('V001', DATE '2024-03-15', 2850.4, 'disponible',      95, 1, 1),
    ('V002', DATE '2024-03-15', 2410.0, 'disponible',      80, 1, 1),
    ('V003', DATE '2024-05-02', 1980.7, 'disponible',      30, 2, 1),
    ('V004', DATE '2024-05-02', 1730.2, 'disponible',      60, 2, 2),
    ('V005', DATE '2023-09-10', 3520.9, 'disponible',      45, 4, 2),
    ('V006', DATE '2025-01-20',  890.5, 'disponible',     100, 1, 3),
    ('V007', DATE '2025-01-20',  940.1, 'disponible',      75, 1, 3),
    ('V008', DATE '2025-02-11',  610.0, 'disponible',      55, 3, 3),
    ('V009', DATE '2024-07-07', 1520.3, 'disponible',      20, 2, 4),
    ('V010', DATE '2023-09-10', 4105.6, 'maintenance',      0, 4, NULL),
    ('V011', DATE '2025-04-01',  420.8, 'disponible',      90, 1, 4),
    ('V012', DATE '2024-07-07', 1688.0, 'disponible',      15, 2, 4),
    ('V013', DATE '2024-10-12', 1205.4, 'disponible',      85, 1, 5),
    ('V014', DATE '2024-10-12', 1102.9, 'disponible',      70, 3, 5),
    ('V015', DATE '2025-03-03',  530.0, 'disponible',      40, 2, 6),
    ('V016', DATE '2026-09-01',    0.0, 'disponible',     100, 1, 8),
    ('V017', DATE '2025-06-18',  310.6, 'disponible',      65, 4, 9),
    ('V018', DATE '2024-01-25', 2950.2, 'maintenance',     10, 3, NULL),
    ('V019', DATE '2025-05-05',  780.4, 'en_utilisation',  70, 1, NULL),
    ('V020', DATE '2025-05-05',  655.7, 'en_utilisation',  88, 2, NULL),
    ('V021', DATE '2023-06-30', 5210.0, 'hors_service',     0, 4, NULL),
    ('V022', DATE '2026-10-15',    0.0, 'disponible',      77, 2, 10);


INSERT INTO adherent (nom, prenom, adresse, email, telephone, date_adhesion, id_commune) VALUES
    ('Martin',  'Léa',    '12 rue Peydavant',           'lea.martin@example.com',     '0600000001', DATE '2024-02-10', 1),   -- 1
    ('Dubois',  'Hugo',   '5 avenue Jean Jaurès',       'hugo.dubois@example.com',    '0600000002', DATE '2024-04-22', 2),   -- 2
    ('Bernard', 'Inès',   '48 cours de l''Argonne',     'ines.bernard@example.com',   '0600000003', DATE '2024-09-03', 3),   -- 3
    ('Petit',   'Lucas',  '3 rue Roustaing',            'lucas.petit@example.com',    '0600000004', DATE '2025-01-15', 1),   -- 4
    ('Robert',  'Chloé',  '27 avenue Pasteur',          'chloe.robert@example.com',   '0600000005', DATE '2025-03-08', 2),   -- 5
    ('Richard', 'Nathan', '9 avenue de la Marne',       'nathan.richard@example.com', '0600000006', DATE '2025-06-30', 4),   -- 6
    ('Durand',  'Manon',  '16 cours du Général Leclerc','manon.durand@example.com',   '0600000007', DATE '2025-09-12', 5),   -- 7
    ('Moreau',  'Yanis',  '31 rue Camille Pelletan',    'yanis.moreau@example.com',   '0600000008', DATE '2026-01-05', 1),   -- 8
    ('Laurent', 'Emma',   '2 rue Sainte-Catherine',     'emma.laurent@example.com',   '0600000009', DATE '2026-10-28', 3);   -- 9



INSERT INTO emprunt (reference, id_adherent, id_station_depart, date_heure_depart,
                     id_station_arrivee, date_heure_retour, distance_parcourue) VALUES
    -- V001 : 11 trajets
    ('V001', 4, 1, CURRENT_DATE - 28 + TIME '08:10', 3, CURRENT_DATE - 28 + TIME '08:20', 0.9),
    ('V001', 5, 3, CURRENT_DATE - 26 + TIME '17:30', 1, CURRENT_DATE - 26 + TIME '17:40', 0.8),
    ('V001', 4, 1, CURRENT_DATE - 23 + TIME '09:00', 2, CURRENT_DATE - 23 + TIME '09:12', 1.3),
    ('V001', 6, 2, CURRENT_DATE - 21 + TIME '12:00', 1, CURRENT_DATE - 21 + TIME '12:10', 1.2),
    ('V001', 4, 1, CURRENT_DATE - 18 + TIME '08:00', 4, CURRENT_DATE - 18 + TIME '08:15', 1.6),
    ('V001', 7, 4, CURRENT_DATE - 15 + TIME '18:00', 1, CURRENT_DATE - 15 + TIME '18:14', 1.5),
    ('V001', 5, 1, CURRENT_DATE - 12 + TIME '07:45', 3, CURRENT_DATE - 12 + TIME '07:53', 0.9),
    ('V001', 3, 3, CURRENT_DATE - 9  + TIME '19:00', 1, CURRENT_DATE - 9  + TIME '19:09', 0.8),
    ('V001', 4, 1, CURRENT_DATE - 6  + TIME '08:00', 5, CURRENT_DATE - 6  + TIME '08:25', 3.6),
    ('V001', 8, 5, CURRENT_DATE - 5  + TIME '17:00', 1, CURRENT_DATE - 5  + TIME '17:24', 3.5),
    ('V001', 6, 1, CURRENT_DATE - 1  + TIME '10:00', 1, CURRENT_DATE - 1  + TIME '10:40', 6.2),
    -- Autres vélos
    ('V002', 5, 3, CURRENT_DATE - 12 + TIME '18:00', 1, CURRENT_DATE - 12 + TIME '18:10', 0.8),
    ('V002', 7, 2, CURRENT_DATE - 40 + TIME '09:30', 1, CURRENT_DATE - 40 + TIME '09:42', 1.3),
    ('V004', 3, 1, CURRENT_DATE - 2  + TIME '08:00', 2, CURRENT_DATE - 2  + TIME '08:12', 1.2),
    ('V013', 3, 2, CURRENT_DATE - 2  + TIME '18:00', 5, CURRENT_DATE - 2  + TIME '18:20', 2.7),
    ('V006', 8, 5, CURRENT_DATE - 20 + TIME '09:00', 3, CURRENT_DATE - 20 + TIME '09:30', 3.5),
    ('V007', 1, 1, CURRENT_DATE - 35 + TIME '14:00', 3, CURRENT_DATE - 35 + TIME '14:10', 0.9),
    ('V007', 2, 4, CURRENT_DATE - 3  + TIME '16:00', 3, CURRENT_DATE - 3  + TIME '16:10', 1.1),
    ('V011', 6, 3, CURRENT_DATE - 4  + TIME '11:00', 4, CURRENT_DATE - 4  + TIME '11:12', 1.1),
    ('V013', 8, 6, CURRENT_DATE - 60 + TIME '08:00', 5, CURRENT_DATE - 60 + TIME '08:10', 1.9),
    ('V014', 2, 7, CURRENT_DATE - 7  + TIME '08:30', 5, CURRENT_DATE - 7  + TIME '08:42', 2.3),
    ('V017', 5, 8, CURRENT_DATE - 8  + TIME '13:00', 9, CURRENT_DATE - 8  + TIME '13:07', 1.4),
    ('V010', 7, 4, CURRENT_DATE - 14 + TIME '08:00', 3, CURRENT_DATE - 14 + TIME '08:10', 1.0),
    ('V018', 1, 5, CURRENT_DATE - 25 + TIME '07:30',10, CURRENT_DATE - 25 + TIME '07:55', 4.6),
    ('V003', 1, 2, CURRENT_DATE - 11 + TIME '12:00', 1, CURRENT_DATE - 11 + TIME '12:12', 1.2),
    ('V012', 3, 3, CURRENT_DATE - 16 + TIME '08:00', 4, CURRENT_DATE - 16 + TIME '08:10', 1.1),
    ('V015', 6, 5, CURRENT_DATE - 9  + TIME '18:00', 6, CURRENT_DATE - 9  + TIME '18:15', 1.9),
    -- Emprunts en cours
    ('V019', 1, 2, CURRENT_TIMESTAMP - INTERVAL '25 minutes', NULL, NULL, NULL),
    ('V020', 2, 5, CURRENT_TIMESTAMP - INTERVAL '10 minutes', NULL, NULL, NULL);


INSERT INTO intervention (reference, date_intervention, nature, duree_heures) VALUES
    ('V010', CURRENT_DATE - 150, 'Révision générale',           2.0),
    ('V010', CURRENT_DATE - 13,  'Remplacement de la batterie', 6.0),
    ('V018', CURRENT_DATE - 24,  'Crevaison roue arrière',      1.5),
    ('V018', CURRENT_DATE - 2,   'Freins défectueux',           3.0),
    ('V003', CURRENT_DATE - 200, 'Révision générale',           2.0),
    ('V012', CURRENT_DATE - 90,  'Changement de chaîne',        1.0),
    ('V012', CURRENT_DATE - 30,  'Réglage des freins',          0.5),
    ('V021', CURRENT_DATE - 30,  'Cadre fissuré : diagnostic',  4.0),
    ('V005', CURRENT_DATE - 400, 'Réglage du dérailleur',       0.5);


