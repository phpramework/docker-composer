FROM quay.io/phpramework/php-fpm

MAINTAINER phpramework <phpramework@gmail.com>

RUN apk update --no-cache \
    && apk add --no-cache \
        git \
        openssl


ENV COMPOSER_HOME=/composer \
    COMPOSER_ALLOW_SUPERUSER=1

RUN mkdir -p $COMPOSER_HOME

COPY install-composer.sh /usr/local/bin/install-composer.sh

RUN cd /tmp \
    && install-composer.sh \
    && composer global require -a "hirak/prestissimo:^0.3" \
    && rm -rf /var/cache/apk/* /var/tmp/* /tmp/*

ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

VOLUME ["/project", "$COMPOSER_HOME/cache"]

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh", "composer"]
CMD ["--version"]
