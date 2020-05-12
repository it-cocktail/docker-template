#!/bin/sh

docker-compose -p "$PROJECTNAME" -f docker-compose/docker-compose.yml exec php crontab -u www-data /tmp/crontab

exit
