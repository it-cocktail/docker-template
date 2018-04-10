#!/bin/sh

printf "updating container images if needed ...\n"
docker-compose -p "$PROJECTNAME" -f docker-data/config/docker-compose.yml $ADDITIONAL_CONFIGFILE pull | grep '^Status'

exit
