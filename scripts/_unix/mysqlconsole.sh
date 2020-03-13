#!/bin/sh

$KUBECTLCMD exec -it "$PROJECTNAME-db-app" --container db -- bash

exit
