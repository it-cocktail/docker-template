#!/bin/sh

JSONPATH="{range .items[?(@.metadata.name=='${PROJECTNAME}-db-app')]}{range .status.containerStatuses[?(@.name=='db')]}{.containerID}{end}"
CONTAINER=$(kubectl get pods -o jsonpath="$JSONPATH" | sed 's/docker:\/\///g')

docker exec -it -u mysql:mysql $CONTAINER bash

exit
