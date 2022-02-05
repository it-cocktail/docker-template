#!/bin/sh

$KUBECTLCMD exec -it "app" --container php -n "$PROJECTNAME" -- apachectl gracefull

exit
