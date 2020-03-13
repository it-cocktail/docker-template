#!/bin/sh

$KUBECTLCMD exec -it "$PROJECTNAME-app" --container php -- sudo -u www-data -E HOME=/var/www crontab /tmp/crontab

exit
