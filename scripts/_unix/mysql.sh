#!/bin/sh

PARAMETER="$@"
$KUBECTLCMD exec -it "db-app" --container db -n "$PROJECTNAME" -- mysql $PARAMETER

exit
