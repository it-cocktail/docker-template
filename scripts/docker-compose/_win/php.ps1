docker-compose --project-directory "$env:CWD" -p "$env:PROJECTNAME" -f docker-compose\docker-compose.yml exec php bash -c "sudo -u www-data bash -l -c 'php $args'"

exit
