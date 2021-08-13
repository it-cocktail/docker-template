#!/bin/sh

test -t 1 && export COMPOSE_INTERACTIVE_NO_CLI=0 || export COMPOSE_INTERACTIVE_NO_CLI=1

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