#!/bin/sh

if [ ! -f "$(pwd)/.env" ]; then
    echo "Environment File missing. Rename .env-dist to .env and customize it before starting this project."
    exit
fi

if [ ! -d "$(pwd)/docker-data/config" ]; then
    echo "docker-data/config is missing. Rename docker-data/config-dist to docker-data/config and customize it before starting this project."
    exit
fi

# Setting permissions
chmod -R 777 docker-data/config/container/* 2>/dev/null
chmod -R 777 docker-data/volumes/* 2>/dev/null

# Read .env file
loadENV() {
    local IFS=$'\n'
    for VAR in $(cat .env | grep -v "^#"); do
        eval $(echo "$VAR" | sed 's/=\(.*\)/="\1"/')
    done
}
loadENV

if [ -z "$PROJECTNAME" ]; then
    PROJECTNAME="${PWD##*/}"
fi
