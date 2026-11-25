# Makefile : lancer le site web de la flotte de vélos
#
#   make            -> affiche l'aide
#   make run        -> config + base + serveur web (tout en un)
#
# Variables modifiables :  make run DB_USER=moi DB_PASS=secret PORT=9000

DB_HOST ?= localhost
DB_PORT ?= 5432
DB_NAME ?= flotte_velos
DB_USER ?= $(USER)
DB_PASS ?=
PORT    ?= 8000

export PGHOST     = $(DB_HOST)
export PGPORT     = $(DB_PORT)
export PGUSER     = $(DB_USER)
export PGPASSWORD = $(DB_PASS)

PSQL = psql -v ON_ERROR_STOP=1 -q -d $(DB_NAME)

.PHONY: help run config createdb db reset serve clean

help:
	@echo "make run      : config + base + serveur web"
	@echo "make config   : crée web/config.php à partir des variables DB_*"
	@echo "make createdb : crée la base $(DB_NAME) si elle n'existe pas"
	@echo "make db       : drop + create + insert + fonctions (consult.sql)"
	@echo "make serve    : lance le site sur http://localhost:$(PORT)"
	@echo "make clean    : supprime web/config.php"

run: config db serve

config: web/config.php

web/config.php:
	@printf "<?php\n\$$DB_HOST = '%s';\n\$$DB_PORT = '%s';\n\$$DB_NAME = '%s';\n\$$DB_USER = '%s';\n\$$DB_PASS = '%s';\n" \
		"$(DB_HOST)" "$(DB_PORT)" "$(DB_NAME)" "$(DB_USER)" "$(DB_PASS)" > $@
	@echo "web/config.php créé (modifiez-le ou faites 'make clean' pour le régénérer)"

createdb:
	@psql -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$(DB_NAME)'" | grep -q 1 \
		|| createdb $(DB_NAME)

db: createdb
	$(PSQL) -f sql/drop.sql
	$(PSQL) -f sql/create.sql
	$(PSQL) -f sql/insert.sql
	$(PSQL) -f sql/consult.sql

reset: db

serve: config
	@echo "Site : http://localhost:$(PORT)  (Ctrl+C pour arrêter)"
	php -S localhost:$(PORT) -t web

clean:
	rm -f web/config.php
