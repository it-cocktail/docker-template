$PROJECTNAME = $envHash.PROJECTNAME

Invoke-Expression "& { kubectl exec -it "$PROJECTNAME-db-app" --container db -- bash }"

exit
