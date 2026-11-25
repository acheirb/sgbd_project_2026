
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
    CONSTRAINT ck_velo_utilisation_station CHECK (etat <> 'en_utilisation' OR id_station IS NULL),
    -- un vélo disponible est forcément garé dans une station
    CONSTRAINT ck_velo_disponible_station CHECK (etat <> 'disponible' OR id_station IS NOT NULL)
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
    date_heure_arrivee               TIMESTAMP                       ,
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
    CONSTRAINT ck_emprunt_dates CHECK (date_heure_arrivee IS NULL OR date_heure_arrivee > date_heure_depart),
    CONSTRAINT ck_emprunt_distance CHECK (distance_parcourue IS NULL OR distance_parcourue >= 0),
    -- la date d'arrivee et la station d'arrivée sont renseignées ensemble
    CONSTRAINT ck_emprunt_arrivee CHECK ((date_heure_arrivee IS NULL) = (id_station_arrivee IS NULL))
);


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

-- ---------------------------------------------------------------------------
-- Règles de disponibilité
-- Hypothèses : batterie minimale pour emprunter = 20 %, adhésion valable 1 an.
-- ---------------------------------------------------------------------------

-- Un vélo ne peut pas faire l'objet de plusieurs emprunts simultanés
CREATE UNIQUE INDEX uq_emprunt_velo_en_cours
    ON emprunt (reference) WHERE date_heure_arrivee IS NULL;

-- Un adhérent ne peut avoir qu'un seul emprunt en cours
CREATE UNIQUE INDEX uq_emprunt_adherent_en_cours
    ON emprunt (id_adherent) WHERE date_heure_arrivee IS NULL;

-- Une station ne peut pas accueillir plus de vélos que sa capacité
CREATE FUNCTION trg_velo_capacite() RETURNS TRIGGER AS $$
DECLARE
    v_bornes INTEGER;
    v_nb     INTEGER;
BEGIN
    IF NEW.id_station IS NULL THEN
        RETURN NEW;
    END IF;
    -- verrou sur la station : deux dépôts simultanés ne peuvent pas dépasser la capacité
    SELECT nb_bornes INTO v_bornes FROM station WHERE id_station = NEW.id_station FOR UPDATE;
    SELECT COUNT(*) INTO v_nb FROM velo
    WHERE id_station = NEW.id_station AND reference <> NEW.reference;
    IF v_nb >= v_bornes THEN
        RAISE EXCEPTION 'Station % pleine (% bornes)', NEW.id_station, v_bornes;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_velo_capacite
    BEFORE INSERT OR UPDATE OF id_station ON velo
    FOR EACH ROW EXECUTE FUNCTION trg_velo_capacite();

-- On ne peut pas réduire la capacité d'une station sous le nombre de vélos présents
CREATE FUNCTION trg_station_bornes() RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM velo WHERE id_station = NEW.id_station) > NEW.nb_bornes THEN
        RAISE EXCEPTION 'Station % : % bornes, mais plus de vélos présents', NEW.id_station, NEW.nb_bornes;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_station_bornes
    BEFORE UPDATE OF nb_bornes ON station
    FOR EACH ROW EXECUTE FUNCTION trg_station_bornes();

-- Départ d'un emprunt : vélo disponible, batterie suffisante, vélo présent dans la
-- station de départ, adhésion valide. (Les trajets déjà terminés insérés d'un bloc,
-- avec une date d'arrivée, ne sont pas contrôlés : ce sont des données historiques.)
CREATE FUNCTION trg_emprunt_depart() RETURNS TRIGGER AS $$
DECLARE
    c_batterie_min CONSTANT INTEGER := 20;
    v_etat         velo.etat%TYPE;
    v_batterie     velo.niveau_batterie%TYPE;
    v_station      velo.id_station%TYPE;
    v_adhesion     adherent.date_adhesion%TYPE;
BEGIN
    IF NEW.date_heure_arrivee IS NOT NULL THEN
        RETURN NEW;
    END IF;

    SELECT etat, niveau_batterie, id_station INTO v_etat, v_batterie, v_station
    FROM velo WHERE reference = NEW.reference FOR UPDATE;

    IF v_etat IS DISTINCT FROM 'disponible' THEN
        RAISE EXCEPTION 'Le vélo % n''est pas disponible (état : %)', NEW.reference, v_etat;
    END IF;
    IF v_batterie < c_batterie_min THEN
        RAISE EXCEPTION 'Le vélo % a une batterie insuffisante (% %%, minimum % %%)',
            NEW.reference, v_batterie, c_batterie_min;
    END IF;
    IF v_station IS DISTINCT FROM NEW.id_station_depart THEN
        RAISE EXCEPTION 'Le vélo % n''est pas dans la station de départ %', NEW.reference, NEW.id_station_depart;
    END IF;

    SELECT date_adhesion INTO v_adhesion FROM adherent WHERE id_adherent = NEW.id_adherent;
    IF CAST(v_adhesion + INTERVAL '1 year' AS DATE) < CAST(NEW.date_heure_depart AS DATE) THEN
        RAISE EXCEPTION 'L''adhésion de l''adhérent % a expiré', NEW.id_adherent;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_emprunt_depart
    BEFORE INSERT ON emprunt
    FOR EACH ROW EXECUTE FUNCTION trg_emprunt_depart();

-- Le vélo quitte sa station au départ de l'emprunt
CREATE FUNCTION trg_emprunt_apres_depart() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date_heure_arrivee IS NULL THEN
        UPDATE velo SET etat = 'en_utilisation', id_station = NULL WHERE reference = NEW.reference;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_emprunt_apres_depart
    AFTER INSERT ON emprunt
    FOR EACH ROW EXECUTE FUNCTION trg_emprunt_apres_depart();

-- À la restitution : le vélo est garé dans la station d'arrivée (capacité contrôlée
-- par trg_velo_capacite) et son kilométrage augmente de la distance parcourue
CREATE FUNCTION trg_emprunt_arrivee() RETURNS TRIGGER AS $$
BEGIN
    UPDATE velo
    SET kilometrage = kilometrage + COALESCE(NEW.distance_parcourue, 0),
        etat        = CASE WHEN etat = 'en_utilisation' THEN 'disponible' ELSE etat END,
        id_station  = CASE WHEN etat = 'en_utilisation' THEN NEW.id_station_arrivee ELSE id_station END
    WHERE reference = NEW.reference;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_emprunt_arrivee
    AFTER UPDATE OF date_heure_arrivee ON emprunt
    FOR EACH ROW
    WHEN (OLD.date_heure_arrivee IS NULL AND NEW.date_heure_arrivee IS NOT NULL)
    EXECUTE FUNCTION trg_emprunt_arrivee();
