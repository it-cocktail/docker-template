#!/bin/sh

$KUBECTLCMD exec -it "app" --container php -n "$PROJECTNAME" -- apachectl graceful

exit
