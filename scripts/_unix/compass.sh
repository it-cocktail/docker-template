#!/bin/sh

docker pull fduarte42/docker-compass
docker run --rm -t -v "$CWD/$HTDOCS_FOLDER:/var/www/html" -u www-data fduarte42/docker-compass "$@"

exit
