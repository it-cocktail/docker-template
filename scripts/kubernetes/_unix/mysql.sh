#!/bin/sh

PARAMETER="$@"
$KUBECTLCMD exec -it "db" --container db -n "$PROJECTNAME" -- mysql $PARAMETER

exit
