#!/bin/sh

(. scripts/docker-compose/_unix/$RUNTIME/stop.sh)
(. scripts/docker-compose/_unix/$RUNTIME/start.sh)

exit
