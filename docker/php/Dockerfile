FROM php:8.2-fpm-alpine

COPY --from=mlocati/php-extension-installer  /usr/bin/install-php-extensions /usr/local/bin/
RUN apk add --no-cache \
		acl \
		fcgi \
		file \
        postgresql-dev \
		gettext \
		git \
		autoconf \
	;
RUN set -eux; \
    install-php-extensions \
    	intl \
    	zip \
    	pdo_pgsql \
    	apcu \
		opcache \
    	redis \
    ;
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"
COPY --from=composer/composer:2-bin  /composer /usr/bin/composer
