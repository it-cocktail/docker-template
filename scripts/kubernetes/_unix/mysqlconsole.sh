#!/bin/sh

$KUBECTLCMD exec -it "db" --container db -n "$PROJECTNAME" -- bash

exit
