#!/bin/sh

PARAMETER="$@"
$KUBECTLCMD exec -it "$PROJECTNAME-app" --container php -- sudo -u www-data -E HOME=/var/www php $PARAMETER

exit
