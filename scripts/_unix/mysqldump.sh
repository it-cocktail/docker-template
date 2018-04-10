#!/bin/sh

PARAMETER="$@"
docker-compose -p "$PROJECTNAME" -f docker-data/config/docker-compose.yml $ADDITIONAL_CONFIGFILE exec db mysqldump "$PARAMETER"

exit
