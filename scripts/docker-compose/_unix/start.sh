#!/bin/sh

export MAIL_VIRTUAL_HOST="mail.$BASE_DOMAIN, mailhog.$BASE_DOMAIN"
export PHPMYADMIN_VIRTUAL_HOST="phpmyadmin.$BASE_DOMAIN"

PHP_VIRTUAL_HOST="www.$BASE_DOMAIN, $BASE_DOMAIN"
PHP_APACHE_ALIAS="localhost"
if [ -f "$(pwd)/docker-compose/container/php/apache2/aliases.txt" ]; then
    loadAliasDomain() {
        local IFS=$'\n'
        for DOMAIN in $(cat docker-compose/container/php/apache2/aliases.txt | grep -v "^#"); do
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

ADDITIONAL_CONFIGFILE=""

if [ -f "$(pwd)/docker-compose/docker-compose.custom.yml" ]; then
    echo "adding custom configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-compose/docker-compose.custom.yml"
fi

ENV_SANATIZED=$(echo $ENVIRONMENT | tr "[:upper:]/\\.:," "[:lower:]-----")
if [ -f "$(pwd)/docker-compose/docker-compose.$ENV_SANATIZED.yml" ]; then
    echo "adding $ENVIRONMENT configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-compose/docker-compose.$ENV_SANATIZED.yml"
fi

docker-compose --project-directory "$(pwd)" -p "$PROJECTNAME" -f docker-compose/docker-compose.yml $ADDITIONAL_CONFIGFILE pull | grep '^Status'

printf "\nstarting services ...\n"
docker-compose --project-directory "$(pwd)" -p "$PROJECTNAME" -f docker-compose/docker-compose.yml $ADDITIONAL_CONFIGFILE up -d

exit
