$PROJECTNAME = $envHash.PROJECTNAME

kubectl exec -it "db" --container db -n "$PROJECTNAME" -- bash

exit
