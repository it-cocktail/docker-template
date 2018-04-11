#!/bin/sh

PROXY_PORT=$(docker ps | grep "jwilder/nginx-proxy" | sed "s/.*0\.0\.0\.0:\([0-9]*\)->80\/tcp.*/\\1/")

if [ -z "$PROXY_PORT" ]; then
    printf "ERROR: Please start docker proxy. Project can be found on Github under https://github.com/orange-hive/docker-proxy\n\n"
    exit 0
fi

if [ ! -d "$(pwd)/docker-data/config" ]; then
    mv "$(pwd)/docker-data/config-dist" "$(pwd)/docker-data/config"
fi

if [ ! -f "$(pwd)/.env" ]; then
    cp "$(pwd)/.env-dist" "$(pwd)/.env"

    while true; do
        read -p 'PROJECTNAME: ' PROJECTNAME
        sed -i "s/PROJECTNAME=.*/PROJECTNAME=$PROJECTNAME/" "$(pwd)/.env"
    if [ "$PROJECTNAME" ]; then break; fi; done

    php_versions=('5.3' '5.5' '5.6' '7.0' '7.1' '7.2')
    while true; do
        read -p 'PHP_VERSION (5.3, 5.5, 5.6, 7.0, 7.1, [7.2]): ' PHP_VERSION
        if [ ! "$PHP_VERSION" ]; then
            PHP_VERSION='7.2'
        fi
        sed -i "s/PHP_VERSION=.*/PHP_VERSION=$PHP_VERSION/" "$(pwd)/.env"
    if [ arrayContains "$PHP_VERSION" "${php_versions[@]}" ]; then break; fi; done

    mysql_versions=('5.5' '5.7' '8.0')
    while true; do
        read -p 'MYSQL_VERSION (5.5, [5.7], 8.0): ' MYSQL_VERSION
        if [ ! "$MYSQL_VERSION" ]; then
            MYSQL_VERSION='5.7'
        fi
        sed -i "s/MYSQL_VERSION=.*/MYSQL_VERSION=$MYSQL_VERSION/" "$(pwd)/.env"
    if [ arrayContains "$MYSQL_VERSION" "${mysql_versions[@]}" ]; then break; fi; done

    while true; do
        read -p 'MYSQL_ROOT_PASSWORD: ' MYSQL_ROOT_PASSWORD
        sed -i "s/MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD/" "$(pwd)/.env"
    if [ "$MYSQL_ROOT_PASSWORD" ]; then break; fi; done

    phpmyadmin_version=('4,6' '4.7')
    while true; do
        read -p 'PHPMYADMIN_VERSION (4.6, [4.7]): ' PHPMYADMIN_VERSION
        if [ ! "$PHPMYADMIN_VERSION" ]; then
            PHPMYADMIN_VERSION='4.7'
        fi
        sed -i "s/PHPMYADMIN_VERSION=.*/PHPMYADMIN_VERSION=$PHPMYADMIN_VERSION/" "$(pwd)/.env"
    if [ arrayContains "$PHPMYADMIN_VERSION" "${phpmyadmin_version[@]}" ]; then break; fi; done

    boolean_values=('0','1')
    while true; do
        read -p 'PHPMYADMIN_RESTRICTION (1, [0]): ' PHPMYADMIN_RESTRICTION
        if [ ! "$PHPMYADMIN_RESTRICTION" ]; then
            PHPMYADMIN_RESTRICTION='0'
        fi
        sed -i "s/PHPMYADMIN_RESTRICTION=.*/PHPMYADMIN_RESTRICTION=$PHPMYADMIN_RESTRICTION/" "$(pwd)/.env"
    if [ arrayContains "$PHPMYADMIN_RESTRICTION" "${boolean_values[@]}" ]; then break; fi; done

    boolean_values=('0','1')
    while true; do
        read -p 'AUTOPULL (1, [0]): ' AUTOPULL
        if [ ! "$AUTOPULL" ]; then
            AUTOPULL='0'
        fi
        sed -i "s/AUTOPULL=.*/AUTOPULL=$AUTOPULL/" "$(pwd)/.env"
    if [ arrayContains "$AUTOPULL" "${boolean_values[@]}" ]; then break; fi; done

    environment_values=('development' 'test' 'stage' 'production')
    while true; do
        read -p 'ENVIRONMENT ([development], test, stage, production): ' ENVIRONMENT
        if [ ! "$ENVIRONMENT" ]; then
            ENVIRONMENT='development'
        fi
        sed -i "s/ENVIRONMENT=.*/ENVIRONMENT=$ENVIRONMENT/" "$(pwd)/.env"
    if [ arrayContains "$ENVIRONMENT" "${environment_values[@]}" ]; then break; fi; done

    while true; do
        read -p "BASE_DOMAIN [$PROJECTNAME.lvh.me]: " BASE_DOMAIN
        if [ ! "$BASE_DOMAIN" ]; then
            BASE_DOMAIN="$PROJECTNAME.lvh.me"
        fi
        sed -i "s/BASE_DOMAIN=.*/BASE_DOMAIN=$BASE_DOMAIN/" "$(pwd)/.env"
    if [ "$BASE_DOMAIN" ] && [ "$BASE_DOMAIN" =~ \.lvh\.me$ ]; then break; fi; done

    while true; do
        read -p 'HTDOCS_FOLDER [htdocs] (directory must exists): ' HTDOCS_FOLDER
        if [ ! "$HTDOCS_FOLDER" ]; then
            HTDOCS_FOLDER='htdocs'
        fi
        sed -i "s/HTDOCS_FOLDER=.*/HTDOCS_FOLDER=$HTDOCS_FOLDER/" "$(pwd)/.env"
    if [ -d "$(pwd)/$HTDOCS_FOLDER" ]; then break; fi; done

    read -p 'DOCUMENT_ROOT: ' DOCUMENT_ROOT
    sed -i "s/DOCUMENT_ROOT=.*/DOCUMENT_ROOT=$DOCUMENT_ROOT/" "$(pwd)/.env"

fi

echo "setup complete"

exit
