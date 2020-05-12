#!/bin/sh
for f in scripts/_unix/*.sh; do
    COMMAND=$(echo $f | sed "s/^scripts\/_unix\/\(.*\)\.sh/\\1/")
    if [[ ! "$COMMAND" =~ ^_ ]]; then
        printf "$COMMAND "
    fi
done
exit
