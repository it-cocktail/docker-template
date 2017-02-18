docker-compose -p "$env:PROJECTNAME" -f docker-data\config\base\docker-compose.yml exec db mysqldump $args

exit
