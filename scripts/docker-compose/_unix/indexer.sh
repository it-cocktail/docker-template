#!/bin/sh

docker-compose -p "$PROJECTNAME" -f docker-compose/docker-compose.yml -f docker-compose/docker-compose.custom.yml exec search bash -l -c "indexer --all --rotate"

exit
