#!/bin/sh

docker compose -p "ingress" -f docker-compose/docker-compose-ingress.yml pull | grep '^Status'

printf "\nstarting ingress ...\n"
docker compose -p "ingress" -f docker-compose/docker-compose-ingress.yml up -d

exit
