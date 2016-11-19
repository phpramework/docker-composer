FROM quay.io/phpramework/php-fpm

MAINTAINER phpramework <phpramework@gmail.com>

RUN apk update --no-cache \
    && apk add --no-cache \
        git \
        openssl

RUN mkdir -p /composer

ENV COMPOSER_HOME=/composer \
    COMPOSER_ALLOW_SUPERUSER=1

COPY install-composer.sh /usr/local/bin/install-composer.sh

RUN cd /tmp \
    && install-composer.sh \
    && composer global require "hirak/prestissimo:^0.3" \
    && composer clear-cache \
    && rm -rf /var/cache/apk/* /var/tmp/* /tmp/*

ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

VOLUME ["/project", "/composer"]

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh", "composer"]
CMD ["--version"]
