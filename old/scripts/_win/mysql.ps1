$PROJECTNAME = $envHash.PROJECTNAME

kubectl exec -it "$PROJECTNAME-db-app" --container db -- mysql $args

exit
