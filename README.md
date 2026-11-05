# Flotte de vélos : projet SGBD 2026

Base de données relationnelle pour gérer une flotte de vélos électriques en libre-service dans une métropole : vélos, stations, adhérents, emprunts et maintenance.

Projet du module SGBD, 2e année informatique. L'énoncé complet se trouve dans [`docs/projet_SGBD_FlotteVelo.pdf`](docs/projet_SGBD_FlotteVelo.pdf).

## Structure

```text
.
├── docs/
│   ├── modelisation/               # Modèles et schémas de la base
│   └── projet_SGBD_FlotteVelo.pdf  # Énoncé
├── rapport/                        # Rapport et hypothèses retenues
└── sql/
    ├── create.sql                  # Création des tables et contraintes
    ├── drop.sql                    # Suppression des objets de la base
    ├── insert.sql                  # Jeu de données
    ├── consult.sql                 # Requêtes de consultation
    ├── stats.sql                   # Requêtes statistiques
    └── update.sql                  # Ajouts, suppressions et modifications
```

## État du projet

L'architecture est en place. Les scripts SQL sont encore vides.
