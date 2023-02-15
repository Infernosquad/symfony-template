FROM caddy:2.6-builder-alpine
RUN xcaddy build \
	--with github.com/dunglas/mercure \
	--with github.com/dunglas/mercure/caddy \
	--with github.com/dunglas/vulcain \
	--with github.com/dunglas/vulcain/caddy


FROM caddy:2.6-alpine
COPY --from=0 /usr/bin/caddy /usr/bin/caddy
