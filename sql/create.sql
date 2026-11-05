
CREATE TABLE commune
(
    id_commune                      SERIAL                  NOT NULL,
    nom_commune                     VARCHAR(40)             NOT NULL,
    code_postal                     VARCHAR(10)             NOT NULL,
    CONSTRAINT pk_commune PRIMARY KEY (id_commune)
);

CREATE TABLE station
(
    id_station                      SERIAL                  NOT NULL,
    nom_station                     VARCHAR(50)             NOT NULL,
    adresse_station                 VARCHAR(100)            NOT NULL,
    latitude                        NUMERIC(8,6)            NOT NULL,
    longitude                       NUMERIC(9,6)            NOT NULL,
    nb_bornes                       INTEGER                 NOT NULL,
    id_commune                      INTEGER                 NOT NULL,
    CONSTRAINT pk_station PRIMARY KEY (id_station),
    CONSTRAINT fk_station_commune FOREIGN KEY (id_commune) REFERENCES commune (id_commune),
    CONSTRAINT ck_station_nb_bornes CHECK (nb_bornes > 0),
    CONSTRAINT ck_station_latitude CHECK (latitude BETWEEN -90 AND 90),
    CONSTRAINT ck_station_longitude CHECK (longitude BETWEEN -180 AND 180)
);


CREATE TABLE distance
(
    station_a                       INTEGER                 NOT NULL,
    station_b                       INTEGER                 NOT NULL,
    distance_km                     NUMERIC(6,2)            NOT NULL,
    CONSTRAINT pk_distance PRIMARY KEY (station_a, station_b),
    CONSTRAINT fk_distance_station_a FOREIGN KEY (station_a) REFERENCES station (id_station),
    CONSTRAINT fk_distance_station_b FOREIGN KEY (station_b) REFERENCES station (id_station),
    CONSTRAINT ck_distance_ordre CHECK (station_a < station_b),
    CONSTRAINT ck_distance_km CHECK (distance_km > 0)
);

CREATE TABLE modele
(
    id_modele                       SERIAL                  NOT NULL,
    nom_modele                      VARCHAR(40)             NOT NULL,
    marque                          VARCHAR(40)             NOT NULL,
    CONSTRAINT pk_modele PRIMARY KEY (id_modele)
);


CREATE TABLE velo
(
    reference                       VARCHAR(10)             NOT NULL,
    date_mise_service               DATE                    NOT NULL,
    kilometrage                     NUMERIC(8,1)            NOT NULL DEFAULT 0,
    etat                            VARCHAR(20)             NOT NULL DEFAULT 'disponible',
    niveau_batterie                 INTEGER                 NOT NULL,
    id_modele                       INTEGER                 NOT NULL,
    id_station                      INTEGER                         ,
    CONSTRAINT pk_velo PRIMARY KEY (reference),
    CONSTRAINT fk_velo_modele FOREIGN KEY (id_modele) REFERENCES modele (id_modele),
    CONSTRAINT fk_velo_station FOREIGN KEY (id_station) REFERENCES station (id_station),
    CONSTRAINT ck_velo_etat CHECK (etat IN ('disponible', 'en_utilisation', 'maintenance', 'hors_service')),
    CONSTRAINT ck_velo_batterie CHECK (niveau_batterie BETWEEN 0 AND 100),
    CONSTRAINT ck_velo_kilometrage CHECK (kilometrage >= 0),
    -- un vélo en cours d'utilisation n'est garé dans aucune station
    CONSTRAINT ck_velo_utilisation_station CHECK (etat <> 'en_utilisation' OR id_station IS NULL)
);

CREATE TABLE adherent
(
    id_adherent                     SERIAL                  NOT NULL,
    nom                             VARCHAR(40)             NOT NULL,
    prenom                          VARCHAR(40)             NOT NULL,
    adresse                         VARCHAR(100)            NOT NULL,
    email                           VARCHAR(100)            NOT NULL,
    telephone                       VARCHAR(20)             NOT NULL,
    date_adhesion                   DATE                    NOT NULL DEFAULT CURRENT_DATE,
    id_commune                      INTEGER                 NOT NULL,
    CONSTRAINT pk_adherent PRIMARY KEY (id_adherent),
    CONSTRAINT fk_adherent_commune FOREIGN KEY (id_commune) REFERENCES commune (id_commune),
    CONSTRAINT uq_adherent_email UNIQUE (email)
);


CREATE TABLE emprunt
(
    id_emprunt                      SERIAL                  NOT NULL,
    date_heure_depart               TIMESTAMP               NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_heure_retour               TIMESTAMP                       ,
    distance_parcourue              NUMERIC(6,2)                    ,
    id_adherent                     INTEGER                 NOT NULL,
    reference                       VARCHAR(10)             NOT NULL,
    id_station_depart               INTEGER                 NOT NULL,
    id_station_arrivee              INTEGER                         ,
    CONSTRAINT pk_emprunt PRIMARY KEY (id_emprunt),
    CONSTRAINT fk_emprunt_adherent FOREIGN KEY (id_adherent) REFERENCES adherent (id_adherent),
    CONSTRAINT fk_emprunt_velo FOREIGN KEY (reference) REFERENCES velo (reference),
    CONSTRAINT fk_emprunt_station_depart FOREIGN KEY (id_station_depart) REFERENCES station (id_station),
    CONSTRAINT fk_emprunt_station_arrivee FOREIGN KEY (id_station_arrivee) REFERENCES station (id_station),
    CONSTRAINT ck_emprunt_dates CHECK (date_heure_retour IS NULL OR date_heure_retour > date_heure_depart),
    CONSTRAINT ck_emprunt_distance CHECK (distance_parcourue IS NULL OR distance_parcourue >= 0),
    -- la date de retour et la station d'arrivée sont renseignées ensemble
    CONSTRAINT ck_emprunt_retour CHECK ((date_heure_retour IS NULL) = (id_station_arrivee IS NULL))
);

-- Un adhérent ne peut avoir qu'un seul emprunt en cours.
CREATE UNIQUE INDEX ux_emprunt_en_cours_adherent ON emprunt (id_adherent) WHERE date_heure_retour IS NULL;
-- Un vélo ne peut pas faire l'objet de plusieurs emprunts simultanés.
CREATE UNIQUE INDEX ux_emprunt_en_cours_velo     ON emprunt (reference)   WHERE date_heure_retour IS NULL;

CREATE TABLE intervention
(
    id_intervention                 SERIAL                  NOT NULL,
    date_intervention               DATE                    NOT NULL,
    nature                          VARCHAR(100)            NOT NULL,
    duree_heures                    NUMERIC(6,2)                    ,
    reference                       VARCHAR(10)             NOT NULL,
    CONSTRAINT pk_intervention PRIMARY KEY (id_intervention),
    CONSTRAINT fk_intervention_velo FOREIGN KEY (reference) REFERENCES velo (reference),
    CONSTRAINT ck_intervention_duree CHECK (duree_heures > 0)
);

-- À faire plus tard (triggers) :
--   - un vélo ne peut être emprunté que s'il est disponible et
--     si sa batterie est suffisante ;
--   - une station ne peut pas accueillir plus de vélos que nb_bornes.
