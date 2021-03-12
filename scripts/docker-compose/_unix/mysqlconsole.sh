#!/bin/sh

docker-compose --project-directory "$(pwd)" -p "$PROJECTNAME" -f docker-compose/docker-compose.yml exec db bash

exit
