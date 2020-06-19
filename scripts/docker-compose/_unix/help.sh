#!/bin/sh

printf "\nDocker template control command\n===============================\n\n"
printf "Available commands:\n\n"

for f in scripts/docker-compose/_unix/*.sh; do
    COMMAND=$(echo $f | sed "s/^scripts\/docker-compose\/_unix\/$RUNTIME\/\(.*\)\.sh/\\1/")
    if [[ ! "$COMMAND" =~ ^_ ]]; then
        printf "$COMMAND\n"
    fi
done

printf "\n\n"

exit
