$PROJECTNAME = $envHash.PROJECTNAME

kubectl exec -it "db" --container db -n "$PROJECTNAME" -- mysql $args

exit
