#!/bin/sh

JSONPATH="{range .items[?(@.metadata.name=='${PROJECTNAME}-app')]}{range .status.containerStatuses[?(@.name=='php')]}{.containerID}{end}"
CONTAINER=$(kubectl get pods -o jsonpath="$JSONPATH" | sed 's/docker:\/\///g')

PARAMETER="$@"
docker exec -it -u www-data:www-data $CONTAINER bash -l -c "php $PARAMETER"

exit
