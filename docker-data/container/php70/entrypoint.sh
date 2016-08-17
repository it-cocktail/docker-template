#!/bin/bash

if [ "$SSH_AUTH_SOCK" = "" -a -x /usr/bin/ssh-agent ]; then
                eval `/usr/bin/ssh-agent`
                /usr/bin/ssh-add
fi

/usr/local/bin/apache2-foreground
