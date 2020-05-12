#!/bin/sh

if [ ! -f "$(pwd)/.env" ]; then
    echo "Environment File missing. Rename .env-dist to .env and customize it before starting this project."
    exit
fi

# Read .env file
loadENV() {
    local IFS=$'\n'
    for VAR in $(cat .env | grep -v "^#"); do
        eval $(echo "$VAR" | sed 's/=\(.*\)/="\1"/')
    done
}
loadENV

COMMAND=$1
shift

if [ "$COMMAND" == "" ]; then
    COMMAND="help"
fi

if [ ! -e "$CWD/scripts/$RUNTIME/_unix/$COMMAND.sh" ]; then
    echo "Error: Command $COMMAND not found. Use help to see available commands."
    exit
fi

# setting permissions
chmod 755 scripts/$RUNTIME/_unix/*.sh 2>/dev/null

. scripts/$RUNTIME/_unix/_global.sh
. scripts/$RUNTIME/_unix/$COMMAND.sh

