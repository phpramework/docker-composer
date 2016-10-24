FROM php:7.0.12-fpm-alpine

MAINTAINER phpramework <phpramework@gmail.com>

RUN apk update --no-cache \
    && apk add --no-cache \
        su-exec

RUN apk add --no-cache  --virtual .pecl-deps \
        autoconf \
        gcc \
        make \
        musl-dev \
    && pecl install --onlyreqdeps apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-install \
        mysqli \
        opcache \
        pdo_mysql \
    && apk del --no-cache --purge -r .pecl-deps

RUN printf "date.timezone = UTC\n" > $PHP_INI_DIR/conf.d/timezone-utc.ini

RUN mkdir -p /composer

ENV COMPOSER_HOME /composer

COPY install-composer.sh /usr/local/bin/install-composer.sh

RUN cd /tmp \
    && install-composer.sh \
    && rm -rf /var/cache/apk/* /var/tmp/* /tmp/*

ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

VOLUME ["/project", "/composer"]

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh", "composer"]
CMD ["--version"]
