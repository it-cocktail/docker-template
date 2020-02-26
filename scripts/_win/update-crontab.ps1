$PROJECTNAME = $envHash.PROJECTNAME
$JSONPATH = "{range .items[?(@.metadata.name=='$PROJECTNAME-app')]}{range .status.containerStatuses[?(@.name=='php')]}{.containerID}{end}"
$CONTAINER = (Invoke-Expression "kubectl get pods -n ingress-nginx -o jsonpath=`"$JSONPATH`"") -replace 'docker://', ''

Invoke-Expression "& { docker exec -it -u www-data:www-data $CONTAINER crontab /tmp/crontab }"

exit
