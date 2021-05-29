#!/bin/sh

printf "\nstopping ingress ...\n"
docker compose -p "ingress" -f docker-compose/docker-compose-ingress.yml down 2>/dev/null

exit
