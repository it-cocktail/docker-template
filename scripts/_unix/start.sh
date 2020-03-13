#!/bin/sh

if [ -f "kubernetes/configmaps/${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/configmaps/${ENVIRONMENT}.yaml)" | kubectl apply -f -
else
  echo "$(parseFile kubernetes/configmaps/default.yaml)" | kubectl apply -f -
fi

kubectl create secret generic "${PROJECTNAME}-ssh" --from-file=$HOME/.ssh/id_rsa.pub --from-file=$HOME/.ssh/id_rsa

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

if [ -f "kubernetes/app/db-ingress.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/db-ingress.${ENVIRONMENT}.yaml)" | kubectl apply -f -
else
  echo "$(parseFile kubernetes/app/db-ingress.default.yaml)" | kubectl apply -f -
fi

if [ -f "kubernetes/app/app-ingress.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/app-ingress.${ENVIRONMENT}.yaml)" | kubectl apply -f -
else
  echo "$(parseFile kubernetes/app/app-ingress.default.yaml)" | kubectl apply -f -
fi

if [ ! -z "$MYSQL_PORT" ]; then
  echo "$(parseFile kubernetes/app/mysql-service.yaml)" | kubectl apply -f -
fi
exit
