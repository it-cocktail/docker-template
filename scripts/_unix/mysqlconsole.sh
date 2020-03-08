#!/bin/sh

kubectl exec -it "$PROJECTNAME-db-app" --container db -- bash

exit
