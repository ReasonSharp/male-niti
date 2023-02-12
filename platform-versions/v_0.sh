#!/bin/bash

export NGINX_VERSION=1.23.3
export CERTBOT_VERSION=latest
export NODE_VERSION=18.13.0-alpine3.16
export MBAPP_VERSION=latest
export MARIADB_VERSION=10.9.3
export MAILSERVER_VERSION=11.3.1
export PHP_VERSION=8.2.2-fpm-alpine3.17

# DBUpdater
export DBUPDATER_COMMIT="1278320"
export DBUPDATER_FOLDER="./scripts/dbupdater"
export DBUPDATER_BRANCH=master

# MB-APP
export MBAPP_COMMIT=87eacde
export MBAPP_FOLDER="./sources/mb-app"
export MBAPP_BRANCH=main

# WWW
export WWW_COMMIT=0cedc07
export WWW_FOLDER="./sources/www"
export WWW_BRANCH=main

# BlagajnaDB
export BLAGAJNADB_COMMIT=d2c1f32
export BLAGAJNADB_FOLDER="./sources/blagajnadb"
export BLAGAJNADB_BRANCH=main