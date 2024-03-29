## Template for Production ready Symfony 6 application

![ci](https://github.com/infernosquad/symfony-template/actions/workflows/ci.yml/badge.svg)


This template includes following features:

* Symfony 6
* Caddy server with automatic HTTPS
* Redis sessions
* PostgresSQL
* Docker
* Deployment using Docker Machine
* Symfony Mercure (Real Time Pushing Capabilities)
* Symfony Messenger (Asyncronous Workers using Redis Pub/Sub)
* Symfony Mailer Asynchronous
* Symfony Webpack Encore
* Cron Jobs Container
* Codeception Testing

## Installation

`docker-compose up -d`

## Deployment

Tested with Ubuntu 22.04. These steps are required to do only once. After that code will be deployed automatically on push to main branch.

Create SSH keys for the server and paste to github as SSH_KEY

`ssh-keygen -t rsa -b 4096 -C "test@example.com" -f key`

`cat key.pub | ssh b@B 'cat >> .ssh/authorized_keys'`

#### Add GITHUB_SECRETS

Environment: `SSH_HOST, SSH_USER, SSH_KEY`
Global: `DOCKER_HOST, DOCKER_REGISTRY, DOCKER_REGISTRY_USER, DOCKER_REGISTRY_PASSWORD`

#### Add Github Environment Variable

ENV_FILE

```
APP_ENV=prod
HOST=<your host>
POSTGRES_PASSWORD=<your password>
APP_SECRET=<your secret>
CADDY_MERCURE_JWT_SECRET=<your-jwt-secret>
TZ=<client timezone>
````
