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

docker-compose  -p "$PROJECTNAME" -f docker-data/config/base/docker-compose.yml -f docker-data/config/base/docker-compose.java.yml $ADDITIONAL_CONFIGFILE down

exit
