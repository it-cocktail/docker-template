#!/bin/sh

docker-compose -p "$PROJECTNAME" -f docker-compose/docker-compose.yml exec --user www-data php bash

exit
