#!/bin/sh

docker-compose -p "$PROJECTNAME" -f docker-compose/docker-compose.yml exec db bash

exit
