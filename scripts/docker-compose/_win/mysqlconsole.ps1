docker compose --project-directory "$env:CWD" --env-file "$env:CWD\.env" -p "$env:PROJECTNAME" -f docker-compose\docker-compose.yml exec db bash

exit