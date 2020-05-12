#!/bin/sh

PARAMETER="$@"
docker-compose -p "$PROJECTNAME" -f docker-compose/docker-compose.yml exec db mysql "$PARAMETER"

exit
