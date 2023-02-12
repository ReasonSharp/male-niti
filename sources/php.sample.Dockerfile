FROM php:${PHP_VERSION}
RUN    apk update \
    && apk add perl perl-io-socket-ssl perl-digest-hmac perl-term-readkey perl-mime-lite perl-file-mmagic perl-io-socket-inet6 \
    && echo "sendmail_path=/smtp-cli/smtp-cli" >> /usr/local/etc/php/conf.d/php-sendmail.ini \
    && mkdir /smtp-cli \
    && chmod 777 /smtp-cli
WORKDIR /smtp-cli
COPY ./php/smtp-cli .
CMD ["php-fpm"]
EXPOSE 9000