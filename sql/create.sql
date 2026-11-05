CREATE TABLE modele
(
    id_modele                        SERIAL                 NOT NULL,
    nom_modele                       VARCHAR(40)            NOT NULL,
    marque                           VARCHAR(40)            NOT NULL,
    CONSTRAINT pk_modele PRIMARY KEY (id_modele)
);

CREATE TABLE velo
(
    reference                       SERIAL                  NOT NULL,
    data_mise_en_service            DATE                            ,
    kilometrage                     INTEGER                 NOT NULL,
    etat                            VARCHAR(20)             NOT NULL,
    niveau_batterie                 INTEGER                 NOT NULL,
    id_modele                       INTEGER                 NOT NULL,
    CONSTRAINT pk_velo PRIMARY KEY (reference),
    CONSTRAINT fk_velo_modele FOREIGN KEY (id_modele) REFERENCES modele (id_modele)
);

CREATE TABLE adherent
(
    id_adherent                     SERIAL                  NOT NULL,
    nom                             VARCHAR(40)             NOT NULL,
    prenom                          VARCHAR(40)             NOT NULL,
    adresse                         VARCHAR(40)             NOT NULL,
    email                           VARCHAR(40)             NOT NULL,
    telephone                       VARCHAR(20)             NOT NULL,
    date_adhesion                   DATE                            ,
    id_commune                      INTEGER                 NOT NULL,
    CONSTRAINT pk_adherent PRIMARY KEY (id_adherent),
    CONSTRAINT fk_adherent_commune FOREIGN KEY (id_commune) REFERENCES commune (id_commune)
);

CREATE TABLE emprunt
(
    id_emprunt                      SERIAL                  NOT NULL,
    date_heure_depart               TIMESTAMP               NOT NULL,
    date_heure_retour               TIMESTAMP                       ,
    distance_parcourue              INTEGER                 NOT NULL,
    id_adherent                     INTEGER                 NOT NULL,
    reference                       INTEGER                 NOT NULL,
    id_station_depart               INTEGER                 NOT NULL,
    id_station_arrivee              INTEGER                 NOT NULL,
    CONSTRAINT pk_emprunt PRIMARY KEY (id_emprunt),
    CONSTRAINT fk_emprunt_adherent FOREIGN KEY (id_adherent) REFERENCES adherent (id_adherent),
    CONSTRAINT fk_emprunt_velo FOREIGN KEY (reference) REFERENCES velo (reference),
    CONSTRAINT fk_emprunt_station_depart FOREIGN KEY (id_station_depart) REFERENCES station (id_station),
    CONSTRAINT fk_emprunt_station_arrivee FOREIGN KEY (id_station_arrivee) REFERENCES station (id_station)
);

CREATE table commune
(
    id_commune                      SERIAL                  NOT NULL,
    nom_commune                     VARCHAR(40)             NOT NULL,
    code_postal                     VARCHAR(10)             NOT NULL,
    CONSTRAINT pk_commune PRIMARY KEY (id_commune)
)

CREATE TABLE station
(
    id_station       SERIAL         NOT NULL,
    nom_station      VARCHAR(50)    NOT NULL,
    adresse_station  VARCHAR(100)   NOT NULL,
    latitude         NUMERIC(8,6)   NOT NULL,
    longitude        NUMERIC(9,6)   NOT NULL,
    nb_bornes        INTEGER        NOT NULL,
    id_commune       INTEGER        NOT NULL,
    CONSTRAINT pk_station PRIMARY KEY (id_station),
    CONSTRAINT fk_station_commune FOREIGN KEY (id_commune) REFERENCES commune (id_commune),
);

CREATE TABLE intervention
(
    id_intervention    SERIAL        NOT NULL,
    date_intervention  DATE          NOT NULL,
    nature             VARCHAR(100)  NOT NULL,
    duree_heures       NUMERIC(6,2),
    reference          VARCHAR(20)   NOT NULL,
    CONSTRAINT pk_intervention PRIMARY KEY (id_intervention),
    CONSTRAINT fk_intervention_velo FOREIGN KEY (reference) REFERENCES velo (reference),
    CONSTRAINT ck_intervention_duree CHECK (duree_heures > 0)
);

CREATE TABLE distance
(
    station_a    INTEGER       NOT NULL,
    station_b    INTEGER       NOT NULL,
    distance_km  NUMERIC(6,2)  NOT NULL,
    CONSTRAINT pk_distance PRIMARY KEY (station_a, station_b),
    CONSTRAINT fk_distance_station_a FOREIGN KEY (station_a) REFERENCES station (id_station),
    CONSTRAINT fk_distance_station_b FOREIGN KEY (station_b) REFERENCES station (id_station),
    CONSTRAINT ck_distance_ordre CHECK (station_a < station_b),
    CONSTRAINT ck_distance_km CHECK (distance_km > 0)
);