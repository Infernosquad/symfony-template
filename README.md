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
* Symfony Secrets
* Codeception Testing

## Installation

`docker-compose up -d`

## Deployment

Only once, create SSH keys for the server and paste to github as SSH_KEY

ssh-keygen -t rsa -b 4096 -C "test@example.com" -f key

cat key.pub | ssh b@B 'cat >> .ssh/authorized_keys'

**ON THE LOCAL**

`ansible playbook.yml -i inventory`



