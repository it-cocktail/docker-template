#!/bin/sh

if [ ! -d "$JAVA_SRC_FOLDER" ]; then
    echo "No JAVA_SRC_FOLDER specified"
    exit
fi

docker-compose -p "$PROJECTNAME" -f docker-data/config/base/docker-compose.yml -f docker-data/config/base/docker-compose.java.yml exec java /restart.sh

exit
