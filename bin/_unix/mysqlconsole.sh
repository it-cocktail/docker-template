#!/bin/sh

docker-compose -p "$PROJECTNAME" -f docker-data/config/base/docker-compose.yml exec db bash

exit
