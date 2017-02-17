#!/bin/sh

docker-compose -p "$PROJECTNAME" -f docker-data/config/base/docker-compose.yml exec php bash -c "sudo -u www-data bash"

exit
