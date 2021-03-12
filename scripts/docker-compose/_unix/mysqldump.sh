#!/bin/sh

PARAMETER="$@"
docker-compose --project-directory "$(pwd)" -p "$PROJECTNAME" -f docker-compose/docker-compose.yml exec db mysqldump "$PARAMETER"

exit
