docker-compose -p "$env:PROJECTNAME" -f docker-compose\docker-compose.yml exec db mysql $args

exit