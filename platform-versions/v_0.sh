#!/bin/bash

export NGINX_VERSION=1.23.3
export CERTBOT_VERSION=v1.32.2
export NODE_VERSION=18.13.0-alpine3.16
export MBAPP_VERSION=latest

# DBUpdater
export DBUPDATER_COMMIT="1278320"
export DBUPDATER_FOLDER="./scripts/dbupdater"
export DBUPDATER_BRANCH=master

# MB-APP
export MBAPP_COMMIT=87eacde
export MBAPP_FOLDER="./sources/mb-app"
export MBAPP_BRANCH=main

# WWW
export WWW_COMMIT=6d49868
export WWW_FOLDER="./sources/www"
export WWW_BRANCH=main