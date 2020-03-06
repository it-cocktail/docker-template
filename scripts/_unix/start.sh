#!/bin/sh

kubectl apply -f kubernetes/ingress/mandatory.yaml > /dev/null
kubectl apply -f kubernetes/ingress/cloud-generic.yaml > /dev/null

if [ -f "kubernetes/configmaps/${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/configmaps/${ENVIRONMENT}.yaml)" | kubectl apply -f -
else
  echo "$(parseFile kubernetes/configmaps/default.yaml)" | kubectl apply -f -
fi

echo "$(parseFile kubernetes/volumes/container.yaml)" | kubectl apply -f -
echo "$(parseFile kubernetes/volumes/htdocs.yaml)" | kubectl apply -f -

if [ -f "kubernetes/app/db-service.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/db-service.${ENVIRONMENT}.yaml)" | kubectl apply -f -
else
  echo "$(parseFile kubernetes/app/db-service.default.yaml)" | kubectl apply -f -
fi

if [ -f "kubernetes/app/app-service.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/app-service.${ENVIRONMENT}.yaml)" | kubectl apply -f -
else
  echo "$(parseFile kubernetes/app/app-service.default.yaml)" | kubectl apply -f -
fi

echo "$(parseFile kubernetes/ingress/db-ingress.yaml)" | kubectl apply -f -
echo "$(parseFile kubernetes/ingress/app-ingress.yaml)" | kubectl apply -f -

exit
