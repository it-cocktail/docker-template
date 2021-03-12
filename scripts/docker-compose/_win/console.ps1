docker-compose --project-directory "$env:CWD" -p "$env:PROJECTNAME" -f docker-compose\docker-compose.yml exec --user www-data php bash

exit
