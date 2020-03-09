#!/bin/sh

echo "$(parseFile kubernetes/ingress/app-ingress.yaml)" | kubectl delete -f -
echo "$(parseFile kubernetes/ingress/db-ingress.yaml)" | kubectl delete -f -

if [ -f "kubernetes/app/app-service.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/app-service.${ENVIRONMENT}.yaml)" | kubectl delete -f -
else
  echo "$(parseFile kubernetes/app/app-service.default.yaml)" | kubectl delete -f -
fi

if [ -f "kubernetes/app/db-service.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/db-service.${ENVIRONMENT}.yaml)" | kubectl delete -f -
else
  echo "$(parseFile kubernetes/app/db-service.default.yaml)" | kubectl delete -f -
fi

if [ -f "kubernetes/configmaps/${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/configmaps/${ENVIRONMENT}.yaml)" | kubectl delete -f -
else
  echo "$(parseFile kubernetes/configmaps/default.yaml)" | kubectl delete -f -
fi

exit
