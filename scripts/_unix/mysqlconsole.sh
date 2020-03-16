#!/bin/sh

$KUBECTLCMD exec -it "db-app" --container db -n "$PROJECTNAME" -- bash

exit
