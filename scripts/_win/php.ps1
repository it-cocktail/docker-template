$PROJECTNAME = $envHash.PROJECTNAME

kubectl exec -it "app" --container php -n "$PROJECTNAME" -- sudo -u www-data -E HOME=/var/www php $args

exit
