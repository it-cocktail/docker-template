#!/bin/sh

ADDITIONAL_CONFIGFILE=""
if [ ! -z "$JAVA_SRC_FOLDER" ]; then
    if [ -d "$JAVA_SRC_FOLDER" ]; then
        ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.java.yml"
    fi
fi

if [ -f "$(pwd)/docker-data/config/docker-compose.custom.yml" ]; then
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.custom.yml"
fi

if [ -f "$(pwd)/docker-data/config/docker-compose.$ENVIRONMENT.yml" ]; then
    echo "adding $ENVIRONMENT configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.$ENVIRONMENT.yml"
fi

printf "updating container images if needed ...\n"
docker-compose -p "$PROJECTNAME" -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE pull | grep '^Status'

exit
