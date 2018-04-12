#!/bin/sh

PROXY_PORT=$(docker ps | grep "jwilder/nginx-proxy" | sed "s/.*0\.0\.0\.0:\([0-9]*\)->80\/tcp.*/\\1/")

if [ -z "$PROXY_PORT" ]; then
    printf "ERROR: Please start docker proxy. Project can be found on Gitlab under https://github.com/orange-hive/docker-proxy\n\n"
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

if [ $AUTOPULL == "1" ]; then
    printf "updating container images if needed ...\n"
    docker-compose -p "$PROJECTNAME" -f docker-data/config/docker-compose.yml $ADDITIONAL_CONFIGFILE pull | grep '^Status'
fi

printf "\nstarting services ...\n"
docker-compose -p "$PROJECTNAME" -f docker-data/config/docker-compose.yml $ADDITIONAL_CONFIGFILE up -d

if [[ "80" == "$PROXY_PORT" ]]; then
    printf "\nServices:\n\n"
    echo "http://www.$BASE_DOMAIN"
    echo "http://phpmyadmin.$BASE_DOMAIN"
    if [ $ENV_SANATIZED == "development" ]; then
        echo "http://mail.$BASE_DOMAIN"
    fi
else
    printf "\nServices:\n\n"
    echo "http://www.$BASE_DOMAIN:$PROXY_PORT"
    echo "http://phpmyadmin.$BASE_DOMAIN:$PROXY_PORT"
    if [ $ENV_SANATIZED == "development" ]; then
        echo "http://mail.$BASE_DOMAIN:$PROXY_PORT"
    fi
fi

exit
