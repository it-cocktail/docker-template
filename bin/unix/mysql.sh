#!/bin/sh

PARAMETER="$@"
docker-compose -p "$PROJECTNAME" -f docker-data/config/base/docker-compose.yml exec db mysql "$PARAMETER"

exit
