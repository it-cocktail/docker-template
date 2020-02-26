#!/bin/sh

echo "$(parseFile kubernetes/app/db-ingress.yaml)" | kubectl delete -f -
echo "$(parseFile kubernetes/app/db-service.yaml)" | kubectl delete -f -

echo "$(parseFile kubernetes/app/app-ingress.yaml)" | kubectl delete -f -
echo "$(parseFile kubernetes/app/app-service.yaml)" | kubectl delete -f -

echo "$(parseFile kubernetes/volumes/htdocs.yaml)" | kubectl delete -f -
echo "$(parseFile kubernetes/volumes/container.yaml)" | kubectl delete -f -

echo "$(parseFile kubernetes/configmaps/${ENVIRONMENT}.yaml)" | kubectl delete -f -

exit
