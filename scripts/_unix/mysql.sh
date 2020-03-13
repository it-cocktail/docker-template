#!/bin/sh

PARAMETER="$@"
$KUBECTLCMD exec -it "$PROJECTNAME-db-app" --container db -- mysql $PARAMETER

exit
