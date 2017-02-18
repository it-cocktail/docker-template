docker-compose -p "$env:PROJECTNAME" -f docker-data\config\base\docker-compose.yml exec php crontab -u www-data /tmp/crontab
