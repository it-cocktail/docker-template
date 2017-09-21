docker pull fduarte42/docker-compass
docker run --rm -t -v "$env:CWD\$env:HTDOCS_FOLDER`:/var/www/html" -u www-data fduarte42/docker-compass $args

exit
