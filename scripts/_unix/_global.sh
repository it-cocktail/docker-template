#!/bin/sh

CWD_SANATIZED=$(echo "$CWD" | sed 's/\//\\\//g')

# Read .env file
loadENV() {
    local IFS=$'\n'
    for VAR in $(cat .env | grep -v "^#"); do
        eval $(echo "$VAR" | sed 's/=\(.*\)/="\1"/')
    done
}
loadENV

function parseFile() {
    local FILEDATA=$(cat "$1")

    local IFS=$'\n'
    for VAR in $(cat .env | grep -v "^#"); do
        local PLACEHOLDER=$(echo "$VAR" | sed 's/\(.*\)=.*/\1/')
        local VALUE=$(echo "$VAR" | sed 's/.*=\(.*\)/\1/')
        FILEDATA=$(echo "$FILEDATA" | sed "s/{\$$PLACEHOLDER}/$VALUE/g")
    done
    FILEDATA=$(echo "$FILEDATA" | sed "s/{\$CWD}/$CWD_SANATIZED/g")

    echo "$FILEDATA"
}

PROJECTNAME=$(echo $PROJECTNAME | tr "[:upper:]/\\.:," "[:lower:]-----")
ENVIRONMENT=$(echo $ENVIRONMENT | tr "[:upper:]/\\.:," "[:lower:]-----")
