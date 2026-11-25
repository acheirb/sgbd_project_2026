
\set ON_ERROR_STOP off
\pset footer off

\echo
\echo '=========================================================================='
\echo ' A. DÉPART D''UN EMPRUNT  (trigger trg_emprunt_depart + index uniques)'
\echo '=========================================================================='

\echo
\echo '--- A1. Emprunt valide : l''adhérent 1 prend V0002 (station 9, batterie 80 %)'
\echo 'ATTENDU : un id_emprunt ; le vélo passe en_utilisation et n''a plus de station'
BEGIN;
SELECT emprunter(1, 'V0002') AS id_emprunt;
SELECT reference, etat, id_station FROM velo WHERE reference = 'V0002';
ROLLBACK;

\echo
\echo '--- A2. Vélo déjà en cours d''utilisation : l''adhérent 2 prend V0002 juste après'
\echo 'ATTENDU : ERREUR « Le vélo V0002 n''est pas disponible (état : en_utilisation) »'
BEGIN;
SELECT emprunter(1, 'V0002');
SELECT emprunter(2, 'V0002');
ROLLBACK;

\echo
\echo '--- A3. Adhérent déjà en cours d''emprunt : l''adhérent 5 (V0031 en cours) prend V0003'
\echo 'ATTENDU : ERREUR « contrainte unique uq_emprunt_adherent_en_cours »'
BEGIN;
SELECT emprunter(5, 'V0003');
ROLLBACK;

\echo
\echo '--- A4. Vélo hors service (V0038)'
\echo 'ATTENDU : ERREUR « n''est pas disponible (état : hors_service) »'
BEGIN;
SELECT emprunter(1, 'V0038');
ROLLBACK;

\echo
\echo '--- A5. Vélo en maintenance (V0035)'
\echo 'ATTENDU : ERREUR « n''est pas disponible (état : maintenance) »'
BEGIN;
SELECT emprunter(1, 'V0035');
ROLLBACK;

\echo
\echo '--- A6. Batterie insuffisante : V0003 forcé à 19 % (minimum 20 %)'
\echo 'ATTENDU : ERREUR « batterie insuffisante (19 %, minimum 20 %) »'
BEGIN;
UPDATE velo SET niveau_batterie = 19 WHERE reference = 'V0003';
SELECT emprunter(1, 'V0003');
ROLLBACK;

\echo
\echo '--- A7. Batterie à la limite : V0010 est à exactement 20 %'
\echo 'ATTENDU : OK, un id_emprunt'
BEGIN;
SELECT emprunter(1, 'V0010') AS id_emprunt;
ROLLBACK;

\echo
\echo '--- A8. Adhésion expirée : l''adhérent 26 (adhésion il y a 400 jours)'
\echo 'ATTENDU : ERREUR « L''adhésion de l''adhérent 26 a expiré »'
BEGIN;
SELECT emprunter(26, 'V0004');
ROLLBACK;

\echo
\echo '--- A9. Même adhérent après renouvellement de son adhésion'
\echo 'ATTENDU : nouvelle_fin dans un an, puis OK avec un id_emprunt'
BEGIN;
SELECT renouveler_adhesion(26) AS nouvelle_fin;
SELECT emprunter(26, 'V0004') AS id_emprunt;
ROLLBACK;

\echo
\echo '--- A10. Départ d''une station où le vélo n''est pas (V0002 est en station 9, pas 5)'
\echo 'ATTENDU : ERREUR « n''est pas dans la station de départ 5 »'
BEGIN;
INSERT INTO emprunt (id_adherent, reference, id_station_depart) VALUES (1, 'V0002', 5);
ROLLBACK;

\echo
\echo '=========================================================================='
\echo ' B. RESTITUTION  (trigger trg_emprunt_arrivee)'
\echo '=========================================================================='

\echo
\echo '--- B1. V0031 (emprunt en cours depuis la station 1) rendu en station 2'
\echo 'ATTENDU : le vélo redevient disponible en station 2 ; kilométrage 480 -> 481.8'
\echo '          (distance 1.80 lue dans la table distance)'
BEGIN;
SELECT restituer('V0031', 2) AS id_emprunt;
SELECT reference, etat, id_station, kilometrage FROM velo WHERE reference = 'V0031';
ROLLBACK;

\echo
\echo '--- B2. Restitution dans une station pleine (station 19 : 4 bornes, 4 vélos)'
\echo 'ATTENDU : ERREUR « Station 19 pleine (4 bornes) » ; l''emprunt reste en cours'
BEGIN;
SELECT restituer('V0031', 19);
ROLLBACK;

\echo
\echo '=========================================================================='
\echo ' C. CAPACITÉ DES STATIONS  (triggers trg_velo_capacite, trg_station_bornes)'
\echo '=========================================================================='

\echo
\echo '--- C1. Ajouter un vélo dans la station 19, déjà pleine'
\echo 'ATTENDU : ERREUR « Station 19 pleine (4 bornes) »'
BEGIN;
INSERT INTO velo (reference, date_mise_service, etat, niveau_batterie, id_modele, id_station)
VALUES ('V9999', CURRENT_DATE, 'disponible', 80, 1, 19);
ROLLBACK;

\echo
\echo '--- C2. Déplacer un vélo vers la station 19 pleine'
\echo 'ATTENDU : ERREUR « Station 19 pleine (4 bornes) » ; aucun vélo déplacé'
BEGIN;
SELECT deplacer_velos(2, 19, 1);
ROLLBACK;

\echo
\echo '--- C3. Réduire la station 19 à 3 bornes alors qu''elle contient 4 vélos'
\echo 'ATTENDU : ERREUR « Station 19 : 3 bornes, mais plus de vélos présents »'
BEGIN;
UPDATE station SET nb_bornes = 3 WHERE id_station = 19;
ROLLBACK;

\echo
\echo '--- C4. Vélo disponible sans station'
\echo 'ATTENDU : ERREUR « contrainte ck_velo_disponible_station »'
BEGIN;
INSERT INTO velo (reference, date_mise_service, etat, niveau_batterie, id_modele, id_station)
VALUES ('V9999', CURRENT_DATE, 'disponible', 80, 1, NULL);
ROLLBACK;

\echo
\echo '--- C5. Rééquilibrage valide : 2 vélos de la station 9 vers la station 11 (vide)'
\echo 'ATTENDU : deplaces = 2 ; station 9 : 4 -> 2 vélos, station 11 : 0 -> 2 vélos'
BEGIN;
SELECT id_station, COUNT(*) AS avant FROM velo WHERE id_station IN (9, 11) GROUP BY 1 ORDER BY 1;
SELECT deplacer_velos(9, 11, 2) AS deplaces;
SELECT id_station, COUNT(*) AS apres FROM velo WHERE id_station IN (9, 11) GROUP BY 1 ORDER BY 1;
ROLLBACK;

\echo
\echo '=========================================================================='
\echo ' D. MAINTENANCE'
\echo '=========================================================================='

\echo
\echo '--- D1. Mettre en maintenance un vélo en cours d''utilisation (V0031)'
\echo 'ATTENDU : ERREUR « Le vélo V0031 est en cours d''utilisation »'
BEGIN;
SELECT mettre_en_maintenance('V0031', 'Test', 1);
ROLLBACK;

\echo
\echo '--- D2. Maintenance valide de V0014, puis remise en service en station 1'
\echo 'ATTENDU : V0014 en maintenance sans station + intervention du jour, puis de nouveau disponible en station 1'
BEGIN;
SELECT mettre_en_maintenance('V0014', 'Crevaison', 0.5) AS id_intervention;
SELECT reference, etat, id_station FROM velo WHERE reference = 'V0014';
SELECT reference, date_intervention, nature, duree_heures FROM intervention
WHERE reference = 'V0014' ORDER BY id_intervention DESC LIMIT 1;
SELECT terminer_maintenance('V0014', 1);
SELECT reference, etat, id_station FROM velo WHERE reference = 'V0014';
ROLLBACK;

\echo
\echo '--- D3. Remettre en service un vélo qui n''est pas en maintenance (V0001)'
\echo 'ATTENDU : ERREUR « n''est pas en maintenance (état : disponible) »'
BEGIN;
SELECT terminer_maintenance('V0001', 1);
ROLLBACK;

\echo
\echo '--- D4. Remettre en service V0035 dans la station 19 pleine'
\echo 'ATTENDU : ERREUR « Station 19 pleine (4 bornes) » ; V0035 reste en maintenance'
BEGIN;
SELECT terminer_maintenance('V0035', 19);
ROLLBACK;

\echo
\echo '=========================================================================='
\echo ' E. ADHÉSION'
\echo '=========================================================================='

\echo
\echo '--- E1. Renouveler l''adhésion expirée de l''adhérent 27 (Chevalier)'
\echo 'ATTENDU : valide passe de f à t'
BEGIN;
SELECT valide AS avant FROM adhesion('Chevalier', 'Maël');
SELECT renouveler_adhesion(27) AS nouvelle_fin;
SELECT valide AS apres FROM adhesion('Chevalier', 'Maël');
ROLLBACK;

\echo
\echo 'Fin de la démonstration : la base n''a pas été modifiée.'
