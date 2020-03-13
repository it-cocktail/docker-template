#!/bin/sh

if [ -f "kubernetes/configmaps/${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/configmaps/${ENVIRONMENT}.yaml)" | $KUBECTLCMD apply -f -
else
  echo "$(parseFile kubernetes/configmaps/default.yaml)" | $KUBECTLCMD apply -f -
fi

$KUBECTLCMD create secret generic "${PROJECTNAME}-ssh" --from-file=$HOME/.ssh/id_rsa.pub --from-file=$HOME/.ssh/id_rsa

if [ -f "kubernetes/app/db-service.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/db-service.${ENVIRONMENT}.yaml)" | $KUBECTLCMD apply -f -
else
  echo "$(parseFile kubernetes/app/db-service.default.yaml)" | $KUBECTLCMD apply -f -
fi

if [ -f "kubernetes/app/app-service.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/app-service.${ENVIRONMENT}.yaml)" | $KUBECTLCMD apply -f -
else
  echo "$(parseFile kubernetes/app/app-service.default.yaml)" | $KUBECTLCMD apply -f -
fi

if [ -f "kubernetes/app/db-ingress.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/db-ingress.${ENVIRONMENT}.yaml)" | $KUBECTLCMD apply -f -
else
  echo "$(parseFile kubernetes/app/db-ingress.default.yaml)" | $KUBECTLCMD apply -f -
fi

if [ -f "kubernetes/app/app-ingress.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/app-ingress.${ENVIRONMENT}.yaml)" | $KUBECTLCMD apply -f -
else
  echo "$(parseFile kubernetes/app/app-ingress.default.yaml)" | $KUBECTLCMD apply -f -
fi

if [ ! -z "$MYSQL_PORT" ]; then
  echo "$(parseFile kubernetes/app/mysql-service.yaml)" | $KUBECTLCMD apply -f -
fi
exit
