#!/bin/sh

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

echo exporting base container fduarte42/docker-php:$PHP_VERSION ...
TEMP_CONTAINER=$(docker create fduarte42/docker-php:$PHP_VERSION)
docker export $TEMP_CONTAINER > docker-data/config/build/extract.tar
docker rm $TEMP_CONTAINER

echo squashing container ...
docker import docker-data/config/build/extract.tar fduarte42/docker-php:$PHP_VERSION-squashed
rm docker-data/config/build/extract.tar

echo building ...
cat docker-data/config/build/Dockerfile | \
    sed "s/{{php_version}}/$PHP_VERSION-squashed/g" | \
    sed "s/{{base_domain}}/$BASE_DOMAIN/g" | \
    sed "s/{{php_virtual_host}}/$PHP_VIRTUAL_HOST/g" | \
    sed "s/{{php_apache_alias}}/$PHP_APACHE_ALIAS/g" | \
    sed "s/{{document_root}}/$DOCUMENT_ROOT/g" | \
    sed "s/{{environment}}/$ENVIRONMENT/g" | \
    sed "s/{{phpmyadmin_restriction}}/$PHPMYADMIN_RESTRICTION/g" | \
    sed "s/{{htdocs_folder}}/$HTDOCS_FOLDER/g" > docker-data/config/build/Dockerfile.parsed
docker build -t "$PROJECTNAME:latest" --squash -f docker-data/config/build/Dockerfile.parsed .

echo cleanup ...
rm docker-data/config/build/Dockerfile.parsed
docker rmi fduarte42/docker-php:$PHP_VERSION-squashed

echo finished. New image "$PROJECTNAME:latest" built.

exit
