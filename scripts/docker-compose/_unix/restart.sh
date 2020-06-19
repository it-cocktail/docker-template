#!/bin/sh

(. scripts/docker-compose/$RUNTIME/_unix/stop.sh)
(. scripts/docker-compose/$RUNTIME/_unix/start.sh)

exit
