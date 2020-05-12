#!/bin/sh

(. scripts/docker-compose/_unix/stop.sh)
(. scripts/docker-compose/_unix/start.sh)

exit
