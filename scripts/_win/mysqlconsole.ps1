$PROJECTNAME = $envHash.PROJECTNAME

kubectl exec -it "db-app" --container db -n "$PROJECTNAME" -- bash

exit
