FROM php:8.1-fpm-alpine AS symfony_php_build

ENV APP_ENV=prod
WORKDIR /srv/app
# php extensions installer: https://github.com/mlocati/docker-php-extension-installer
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
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY  docker/php/conf.d/app.ini $PHP_INI_DIR/conf.d/
COPY  docker/php/conf.d/app.prod.ini $PHP_INI_DIR/conf.d/
COPY  docker/php/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY crontab.conf /etc/cron.d/root
RUN crontab -u root /etc/cron.d/root
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"
COPY --from=composer/composer:2-bin  /composer /usr/bin/composer
COPY composer.* symfony.* ./
RUN set -eux; \
    if [ -f composer.json ]; then \
		composer install --prefer-dist --no-autoloader --no-scripts --no-progress; \
		composer clear-cache; \
    fi
COPY . .
RUN rm -Rf docker/
RUN set -eux; \
	mkdir -p var/cache var/log; \
    if [ -f composer.json ]; then \
		composer dump-autoload --classmap-authoritative; \
		composer run-script post-install-cmd; \
		chmod +x bin/console; sync; \
    fi
COPY  docker/php/docker-healthcheck.sh /usr/local/bin/docker-healthcheck
COPY docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

FROM node:18-alpine AS symfony_node
WORKDIR /srv/app
COPY --from=symfony_php_build /srv/app .
RUN yarn install
RUN yarn run build

FROM symfony_php_build AS symfony_php
WORKDIR /srv/app
COPY --from=symfony_node /srv/app/public/build /srv/app/public/build
RUN mkdir -p /var/run/php
CMD ["php-fpm"]

# Dev image
FROM symfony_php AS symfony_php_dev
ENV APP_ENV=dev XDEBUG_MODE=off
VOLUME /srv/app/var/
RUN rm $PHP_INI_DIR/conf.d/app.prod.ini; \
	mv "$PHP_INI_DIR/php.ini" "$PHP_INI_DIR/php.ini-production"; \
	mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY docker/php/conf.d/app.dev.ini $PHP_INI_DIR/conf.d/
RUN set -eux; \
	install-php-extensions xdebug
RUN rm -f .env.local.php

# Build Caddy with the Mercure and Vulcain modules
FROM caddy:2.6-builder-alpine AS app_caddy_builder
RUN xcaddy build \
	--with github.com/dunglas/mercure \
	--with github.com/dunglas/mercure/caddy \
	--with github.com/dunglas/vulcain \
	--with github.com/dunglas/vulcain/caddy

# Caddy image
FROM caddy:2.6-alpine AS app_caddy
WORKDIR /srv/app
COPY --from=app_caddy_builder /usr/bin/caddy /usr/bin/caddy
COPY --from=symfony_php  /srv/app/public public/
COPY docker/caddy/Caddyfile /etc/caddy/Caddyfile
