docker-compose -p "$env:PROJECTNAME" -f docker-data\config\base\docker-compose.yml exec db mysql $args

exit