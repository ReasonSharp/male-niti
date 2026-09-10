#!/bin/bash

letsencrypt-init() {
 DATA_PATH="./files/${CERTFOLDER}"
 # -s (non-empty), not just -e: a failed curl below still creates the file via
 # the redirect, and an existence-only check would never retry a corrupt one
 if [ ! -s "${DATA_PATH}/conf/options-ssl-nginx.conf" ] || [ ! -s "${DATA_PATH}/conf/ssl-dhparams.pem" ]; then
   echo "${0}: downloading recommended TLS parameters ..."
   mkdir -p "${DATA_PATH}/conf"
   if ! curl -fsS https://raw.githubusercontent.com/certbot/certbot/main/certbot/src/certbot/_internal/plugins/nginx/tls_configs/options-ssl-nginx.conf > "${DATA_PATH}/conf/options-ssl-nginx.conf"; then
    echo "${0}: failed to download options-ssl-nginx.conf" >&2
    rm -f "${DATA_PATH}/conf/options-ssl-nginx.conf"
    exit 1
   fi
   if ! curl -fsS https://raw.githubusercontent.com/certbot/certbot/main/certbot/src/certbot/ssl-dhparams.pem > "${DATA_PATH}/conf/ssl-dhparams.pem"; then
    echo "${0}: failed to download ssl-dhparams.pem" >&2
    rm -f "${DATA_PATH}/conf/ssl-dhparams.pem"
    exit 1
   fi
   echo
 fi
 
 if [ ! -d "${DATA_PATH}/conf/live/${DOMAINS}" ]; then
  echo "${0}: creating dummy certificate for ${DOMAINS} ..."
  CERT_PATH="/etc/letsencrypt/live/${DOMAINS}"
  mkdir -p "${DATA_PATH}/conf/live/${DOMAINS}"
  docker compose -p mb-platform -f "./docker-compose.yml" run --rm --entrypoint "\
    openssl req -x509 -nodes -newkey rsa:${RSA_KEY_SIZ} -days 1\
      -keyout '${CERT_PATH}/privkey.pem' \
      -out '${CERT_PATH}/fullchain.pem' \
      -subj '/CN=localhost'" certbot
  echo
  
  echo "${0}: starting nginx ..."
  docker compose -p mb-platform -f "./docker-compose.yml" up --force-recreate -d tlsoffloader
  echo

  if [ "${ENV}" = "prod" ]; then
   echo "${0}: deleting dummy certificate for ${DOMAINS} ..."
   docker compose -p mb-platform -f "./docker-compose.yml" run --rm --entrypoint "\
     rm -Rf /etc/letsencrypt/live/${DOMAINS} && \
     rm -Rf /etc/letsencrypt/archive/${DOMAINS} && \
     rm -Rf /etc/letsencrypt/renewal/${DOMAINS}.conf" certbot
   echo
   
   echo "${0}: requesting Let's Encrypt certificate for ${DOMAINS} ..."
   DOMAIN_ARGS=""
   for DOMAIN in "${DOMAINS[@]}"; do
     DOMAIN_ARGS="${DOMAIN_ARGS} -d ${DOMAIN}"
   done
   
   case "${ADMIN_EMAIL}" in
     "") ADMIN_EMAIL_ARG="--register-unsafely-without-email" ;;
     *) ADMIN_EMAIL_ARG="--email ${ADMIN_EMAIL}" ;;
   esac
   
   if [ "${ENV}" != "prod" ]; then STAGING="--staging"; fi
   
   docker compose -p mb-platform -f "./docker-compose.yml" run --rm --entrypoint "\
     certbot certonly -w /var/www/certbot \
       --dns-google \
       --dns-google-credentials /cred.json \
       ${STAGING} \
       ${ADMIN_EMAIL_ARG} \
       ${DOMAIN_ARGS} \
       --rsa-key-size ${RSA_KEY_SIZ} \
       --agree-tos \
       --non-interactive \
       --no-eff-email \
       --force-renewal" certbot
   echo
   
   echo "${0}: reloading nginx ..."
   docker compose -p mb-platform -f "./docker-compose.yml" exec tlsoffloader nginx -s reload

  else
   echo "${0}: not running certbot on ${ENV} environment"
  fi

 else
  echo "${0}: '${DATA_PATH}/conf/live/${DOMAINS}' already exists; if you want new certificates, delete that path first"
 fi
}