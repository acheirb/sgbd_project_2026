-- ============================================================
-- drop.sql : suppression de tous les objets de la base
-- Ordre inverse de la création (les tables qui référencent
-- les autres d'abord). CASCADE supprime aussi les vues,
-- contraintes et triggers qui dépendent de ces tables.
-- ============================================================

DROP TABLE IF EXISTS emprunt      CASCADE;
DROP TABLE IF EXISTS intervention CASCADE;
DROP TABLE IF EXISTS distance     CASCADE;
DROP TABLE IF EXISTS velo         CASCADE;
DROP TABLE IF EXISTS modele       CASCADE;
DROP TABLE IF EXISTS adherent     CASCADE;
DROP TABLE IF EXISTS station      CASCADE;
DROP TABLE IF EXISTS commune      CASCADE;
