FROM php:latest
COPY dbupdater/db* /usr/bin/
RUN apt-get -f install && \
    apt-get update && \
    apt-get install -y default-mysql-client