$PROJECTNAME = $envHash.PROJECTNAME
$JSONPATH = "{range .items[?(@.metadata.name=='$PROJECTNAME-db-app')]}{range .status.containerStatuses[?(@.name=='db')]}{.containerID}{end}"
$CONTAINER = (Invoke-Expression "kubectl get pods -o jsonpath=`"$JSONPATH`"") -replace 'docker://', ''

Invoke-Expression "& { docker exec -it -u mysql:mysql $CONTAINER bash -l -c `"mysql $args`" }"

exit
