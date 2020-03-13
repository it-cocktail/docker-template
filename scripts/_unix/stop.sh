#!/bin/sh

if [ ! -z "$MYSQL_PORT" ]; then
  echo "$(parseFile kubernetes/app/mysql-service.yaml)" | $KUBECTLCMD delete -f -
fi

if [ -f "kubernetes/app/app-ingress.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/app-ingress.${ENVIRONMENT}.yaml)" | $KUBECTLCMD delete -f -
else
  echo "$(parseFile kubernetes/app/app-ingress.default.yaml)" | $KUBECTLCMD delete -f -
fi

if [ -f "kubernetes/app/db-ingress.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/db-ingress.${ENVIRONMENT}.yaml)" | $KUBECTLCMD delete -f -
else
  echo "$(parseFile kubernetes/app/db-ingress.default.yaml)" | $KUBECTLCMD delete -f -
fi

if [ -f "kubernetes/app/app-service.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/app-service.${ENVIRONMENT}.yaml)" | $KUBECTLCMD delete -f -
else
  echo "$(parseFile kubernetes/app/app-service.default.yaml)" | $KUBECTLCMD delete -f -
fi

if [ -f "kubernetes/app/db-service.${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/app/db-service.${ENVIRONMENT}.yaml)" | $KUBECTLCMD delete -f -
else
  echo "$(parseFile kubernetes/app/db-service.default.yaml)" | $KUBECTLCMD delete -f -
fi

$KUBECTLCMD delete secret "${PROJECTNAME}-ssh"

if [ -f "kubernetes/configmaps/${ENVIRONMENT}.yaml" ]; then
  echo "$(parseFile kubernetes/configmaps/${ENVIRONMENT}.yaml)" | $KUBECTLCMD delete -f -
else
  echo "$(parseFile kubernetes/configmaps/default.yaml)" | $KUBECTLCMD delete -f -
fi

exit
