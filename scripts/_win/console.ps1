$PROJECTNAME = $envHash.PROJECTNAME

Invoke-Expression "& { kubectl exec -it "$PROJECTNAME-app" --container php -- sudo -u www-data -E HOME=/var/www bash }"

exit
