#!/bin/bash
set -e

# Install docker
echo "Install docker"
if [[ $(which docker) == "" ]]; then
  chmod +x ./docker/docker.sh
  ./docker/docker.sh
else
  echo "Docker already installed"
fi

# Install traefik
echo "Traefik installation"
mkdir -p /var/www/traefik
cd /var/www/traefik
mv -f "$PROJECT_FOLDER"/docker-compose.traefik.yml /var/www/traefik/docker-compose.yml
cd ../traefik && docker-compose up -d --wait
echo "Traefik installation end"

# Deploy
echo "Deploy project"
cd "$PROJECT_FOLDER"
echo "$ENV_FILE" > .env
mv docker-compose.prod.yml docker-compose.override.yml
echo "DOCKER_REGISTRY=$REGISTRY/$IMAGE_NAME" >> .env
echo "DOCKER_TAG=$DOCKER_TAG" >> .env
echo "TZ=$TZ" >> .env
source .env
echo "$DOCKER_PASSWORD" | docker login "$REGISTRY" --username "$DOCKER_USERNAME" --password-stdin
docker compose pull && docker compose up -d
sudo docker image prune -f
echo "Deploy completed"