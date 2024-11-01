FROM infernosquad/php:v0.3 AS symfony_php_build

ARG TZ
ENV APP_ENV=prod
ENV TZ $TZ
WORKDIR /srv/app
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY  docker/php/conf.d/app.ini $PHP_INI_DIR/conf.d/
COPY  docker/php/conf.d/app.prod.ini $PHP_INI_DIR/conf.d/
COPY  docker/php/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
RUN apk add --no-cache tzdata
RUN echo date.timezone = $TZ > $PHP_INI_DIR/conf.d/tzone.ini

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

# Caddy image
FROM infernosquad/caddy:v0.2 AS app_caddy
WORKDIR /srv/app
RUN apk add --no-cache tzdata
COPY --from=symfony_php  /srv/app/public public/
COPY docker/caddy/Caddyfile /etc/caddy/Caddyfile
