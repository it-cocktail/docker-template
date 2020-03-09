$PROJECTNAME = $envHash.PROJECTNAME

kubectl exec -it "$PROJECTNAME-app" --container php -- sudo -u www-data -E HOME=/var/www COMPOSER_HOME=~/.composer composer $args

exit
