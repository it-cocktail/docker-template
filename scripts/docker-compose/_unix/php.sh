#!/bin/sh

PARAMETER="$@"
docker-compose -p "$PROJECTNAME" -f docker-compose/docker-compose.yml exec php bash -c "sudo -u www-data bash -l -c 'php $PARAMETER'"

exit
