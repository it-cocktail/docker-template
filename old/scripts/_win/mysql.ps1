Invoke-Expression "& { docker-compose -p `"$env:PROJECTNAME`" -f docker-data\config\docker-compose.yml $ADDITIONAL_CONFIGFILE exec db mysql $args }"

exit