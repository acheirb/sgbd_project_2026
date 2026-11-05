CREATE TABLE film
(
    numero_film                     SERIAL                 NOT NULL,
    titre_film                      VARCHAR(40)            NOT NULL,
    date_de_sortie                  DATE                           ,
    duree                           INTEGER                NOT NULL,
    genre                           VARCHAR(20)            NOT NULL,
    numero_realisateur              INTEGER                NOT NULL,
    CONSTRAINT pk_film PRIMARY KEY (numero_film)
);

CREATE TABLE model
(
    id_model                        SERIAL                 NOT NULL,
    
    CONSTRAINT pk_model PRIMARY KEY (id_model)
);
