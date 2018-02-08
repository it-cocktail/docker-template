#!/bin/sh

PROXY_PORT=$(docker ps | grep "jwilder/nginx-proxy" | sed "s/.*0\.0\.0\.0:\([0-9]*\)->80\/tcp.*/\\1/")

if [ -z "$PROXY_PORT" ]; then
    printf "ERROR: Please start docker proxy. Project can be found on Gitlab under http://gitlab.orangehive.de/orangehive/docker-proxy\n\n"
    exit 0
fi

export MAIL_VIRTUAL_HOST="mail.$BASE_DOMAIN, mailhog.$BASE_DOMAIN"
export PHPMYADMIN_VIRTUAL_HOST="phpmyadmin.$BASE_DOMAIN"

PHP_VIRTUAL_HOST="www.$BASE_DOMAIN, $BASE_DOMAIN"
PHP_APACHE_ALIAS="localhost"
if [ -f "$(pwd)/docker-data/config/container/php/apache2/aliases.txt" ]; then
    loadAliasDomain() {
        local IFS=$'\n'
        for DOMAIN in $(cat docker-data/config/container/php/apache2/aliases.txt | grep -v "^#"); do
            DOMAIN=$(echo $DOMAIN | xargs)
            if [ ! -z $DOMAIN ]; then
                PHP_VIRTUAL_HOST="$PHP_VIRTUAL_HOST, $DOMAIN"
                PHP_APACHE_ALIAS="$PHP_APACHE_ALIAS $DOMAIN"
            fi
        done
    }
    loadAliasDomain
fi
export PHP_VIRTUAL_HOST
export PHP_APACHE_ALIAS


DEBUGMODE=0
ADDITIONAL_CONFIGFILE=""
for PARAMETER in "$@"; do
    case "$PARAMETER" in
        "-d")
            ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.debug.yml"
            DEBUGMODE=1
            LOCAL_DEBUG_IP=$(ipconfig getifaddr en0)
            if [ -z $LOCAL_DEBUG_IP ]; then
                LOCAL_DEBUG_IP=$(ipconfig getifaddr en1)
            fi
            export LOCAL_DEBUG_IP
            printf "***DEBUGMODE*** LOCAL_DEBUG_IP: $LOCAL_DEBUG_IP\n\n"
            ;;
        *)
            echo "invalid parameter $PARAMETER"
            exit
            ;;
    esac
done

JAVADEBUGENABLED=0
if [ ! -z "$JAVA_SRC_FOLDER" ]; then
    if [ -d "$JAVA_SRC_FOLDER" ]; then
        ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.java.yml"
        if [ "$DEBUGMODE" == "1" ]; then
            ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.debug_java.yml"
            JAVADEBUGENABLED=1
            export JAVA_VIRTUAL_HOST="java.$BASE_DOMAIN"
        fi
        printf "***Java Service will be activated***\n\n"
    else
        echo "JAVA_SRC_FOLDER not found"
        exit 1
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
    echo "adding custom configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.custom.yml"
fi

ENV_SANATIZED=$(echo $ENVIRONMENT | tr "[:upper:]/\\.:," "[:lower:]-----")
if [ -f "$(pwd)/docker-data/config/docker-compose.$ENV_SANATIZED.yml" ]; then
    echo "adding $ENVIRONMENT configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.$ENV_SANATIZED.yml"
fi

if [ $AUTOPULL == "1" ]; then
    printf "updating container images if needed ...\n"
    docker-compose -p "$PROJECTNAME" -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE pull | grep '^Status'
fi

printf "\nstarting services ...\n"
docker-compose -p "$PROJECTNAME" -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE up -d

if [[ "80" == "$PROXY_PORT" ]]; then
    printf "\nServices:\n\n"
    echo "http://www.$BASE_DOMAIN"
    echo "http://phpmyadmin.$BASE_DOMAIN"
    echo "http://mail.$BASE_DOMAIN"
    if [ "$JAVADEBUGENABLED" == "1" ]; then
        echo "http://java.$BASE_DOMAIN"
    fi
else
    printf "\nServices:\n\n"
    echo "http://www.$BASE_DOMAIN:$PROXY_PORT"
    echo "http://phpmyadmin.$BASE_DOMAIN:$PROXY_PORT"
    echo "http://mail.$BASE_DOMAIN:$PROXY_PORT"
    if [ "$JAVADEBUGENABLED" == "1" ]; then
        echo "http://java.$BASE_DOMAIN:$PROXY_PORT"
    fi
fi

exit
