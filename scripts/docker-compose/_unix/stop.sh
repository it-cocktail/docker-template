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

echo "\nstopping ...\n"
docker compose --project-directory "$(pwd)" --env-file "$(pwd)/.env" --env-file "$(pwd)/.env" -p "$PROJECTNAME" -f docker-compose/docker-compose.yml $ADDITIONAL_CONFIGFILE down 2>/dev/null

exit
