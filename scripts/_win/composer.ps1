docker-compose -p "$env:PROJECTNAME" -f docker-data\config\base\docker-compose.yml exec -u www-data:www-data php bash -l -c "composer $args"

exit
