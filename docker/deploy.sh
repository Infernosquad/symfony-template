#!/bin/bash
set -e

TRAEFIK_FOLDER="/var/www/traefik"

# Install firewall
echo "Install firewall rules"
sudo ufw --force enable
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 8080 # Traefik
sudo ufw allow 9100 # Monitoring
sudo ufw allow 22
echo "Firewall rules installed"

#Install file2ban
echo "Install fail2ban"
sudo apt-get install -y fail2ban
echo "Fail2ban installed"


# Install docker
echo "Install docker"
if [[ $(which docker) == "" ]]; then
  chmod +x ./docker.sh
  ./docker.sh
else
  echo "Docker already installed"
fi

# Install node exporter (Monitoring)
echo "Install node exporter"
if [[ $(which node_exporter) == "" ]]; then
  chmod +x ./node_exporter.sh
  ./node_exporter.sh
else
  echo "Node exporter already installed"
fi


# Install traefik
echo "Traefik installation"
# Install traefik network
docker network create traefik || true
mkdir -p $TRAEFIK_FOLDER
mv -f $PROJECT_FOLDER/compose.traefik.yml $TRAEFIK_FOLDER/compose.yml
cd $TRAEFIK_FOLDER
docker compose up -d --wait
echo "Traefik installation end"

# Deploy
echo "Setup env variables"
cd "$PROJECT_FOLDER"
echo "$ENV_FILE" > .env
mv compose.prod.yml compose.override.yml
echo "DOCKER_REGISTRY=$REGISTRY/$IMAGE_NAME" >> .env
echo "DOCKER_TAG=$DOCKER_TAG" >> .env
echo "TZ=$TZ" >> .env
echo "APP_NAME=$APP_NAME" >> .env
source .env


echo "Pull docker image"
echo "$DOCKER_PASSWORD" | docker login "$REGISTRY" --username "$DOCKER_USERNAME" --password-stdin
docker compose pull && docker compose up -d
sudo docker image prune -f || true
echo "Docker image pulled"
sudo chmod -R a+rw $PROJECT_FOLDER/uploads
echo "Deploy completed"
