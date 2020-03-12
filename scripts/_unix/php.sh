#!/bin/sh

PARAMETER="$@"
kubectl exec -it "$PROJECTNAME-app" --container php -- sudo -u www-data -E HOME=/var/www php $PARAMETER

exit
