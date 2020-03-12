#!/bin/sh

PARAMETER="$@"
kubectl exec -it "$PROJECTNAME-db-app" --container db -- mysql $PARAMETER

exit
