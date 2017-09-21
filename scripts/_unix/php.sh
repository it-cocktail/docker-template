#!/bin/sh

PARAMETER="$@"
docker-compose -p "$PROJECTNAME" -f docker-data/config/base/docker-compose.yml exec -u www-data:www-data php bash -l -c "php $PARAMETER"

exit
