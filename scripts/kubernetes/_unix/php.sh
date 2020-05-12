#!/bin/sh

PARAMETER="$@"
$KUBECTLCMD exec -it "app" --container php -n "$PROJECTNAME" -- sudo -u www-data -E HOME=/var/www php $PARAMETER

exit
