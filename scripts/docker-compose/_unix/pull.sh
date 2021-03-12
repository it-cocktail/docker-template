#!/bin/sh

ADDITIONAL_CONFIGFILE=""
if [ -f "$(pwd)/docker-compose/docker-compose.custom.yml" ]; then
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-compose/docker-compose.custom.yml"
fi

ENV_SANATIZED=$(echo $ENVIRONMENT | tr "[:upper:]/\\.:," "[:lower:]-----")
if [ -f "$(pwd)/docker-compose/docker-compose.$ENV_SANATIZED.yml" ]; then
    echo "adding $ENVIRONMENT configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-compose/docker-compose.$ENV_SANATIZED.yml"
fi

printf "updating container images if needed ...\n"
docker-compose --project-directory "$(pwd)" -p "$PROJECTNAME" -f docker-compose/docker-compose.yml $ADDITIONAL_CONFIGFILE pull | grep '^Status'

exit
