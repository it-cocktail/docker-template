#!/bin/sh

ADDITIONAL_CONFIGFILE=""
if [ ! -z "$JAVA_SRC_FOLDER" ]; then
    if [ -d "$JAVA_SRC_FOLDER" ]; then
        ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.java.yml"
    fi
fi

if [ "$SFTP_ENABLED" == "1" ]; then
    echo "adding sftp configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.sftp.yml"
fi

if [ "$RSYNC_ENABLED" == "1" ]; then
    echo "adding rsync configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.rsync.yml"
fi

if [ -f "$(pwd)/docker-data/config/docker-compose.custom.yml" ]; then
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.custom.yml"
fi

ENV_SANATIZED=$(echo $ENVIRONMENT | tr "[:upper:]/\\.:," "[:lower:]-----")
if [ -f "$(pwd)/docker-data/config/docker-compose.$ENV_SANATIZED.yml" ]; then
    echo "adding $ENVIRONMENT configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.$ENV_SANATIZED.yml"
fi

docker-compose  -p "$PROJECTNAME" -f docker-data/config/base/docker-compose.yml -f docker-data/config/base/docker-compose.java.yml $ADDITIONAL_CONFIGFILE down

exit
