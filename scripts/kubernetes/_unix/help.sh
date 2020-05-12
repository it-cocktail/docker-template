#!/bin/sh

printf "\nDocker template control command\n===============================\n\n"
printf "Available commands:\n\n"

for f in scripts/_unix/*.sh; do
    COMMAND=$(echo $f | sed "s/^scripts\/_unix\/\(.*\)\.sh/\\1/")
    if [[ ! "$COMMAND" =~ ^_ ]]; then
        printf "$COMMAND\n"
    fi
done

printf "\n\n"

exit
