#!/bin/sh

kubectl apply -f kubernetes/ingress/mandatory.yaml > /dev/null
kubectl apply -f kubernetes/ingress/cloud-generic.yaml  > /dev/null

echo "$(parseFile kubernetes/configmaps/${ENVIRONMENT}.yaml)" | kubectl apply -f -

echo "$(parseFile kubernetes/volumes/container.yaml)" | kubectl apply -f -
echo "$(parseFile kubernetes/volumes/htdocs.yaml)" | kubectl apply -f -

echo "$(parseFile kubernetes/app/db-service.yaml)" | kubectl apply -f -
echo "$(parseFile kubernetes/app/db-ingress.yaml)" | kubectl apply -f -

echo "$(parseFile kubernetes/app/app-service.yaml)" | kubectl apply -f -
echo "$(parseFile kubernetes/app/app-ingress.yaml)" | kubectl apply -f -

exit
