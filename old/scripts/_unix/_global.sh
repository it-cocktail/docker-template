#!/bin/sh

if [ ! -f "$(pwd)/.env" ]; then
    echo "Environment File missing. Use setup command to create it."
    exit
fi

if [ ! -d "$(pwd)/docker-data/config" ]; then
    echo "docker-data/config is missing. Use setup command to create it."
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

ADDITIONAL_CONFIGFILE=""

ENV_SANATIZED=$(echo $ENVIRONMENT | tr "[:upper:]/\\.:," "[:lower:]-----")
if [ -f "$(pwd)/docker-data/config/docker-compose.$ENV_SANATIZED.yml" ]; then
    echo "adding $ENVIRONMENT configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.$ENV_SANATIZED.yml"
fi

# utility for searching in bash arrays
arrayContains () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}
