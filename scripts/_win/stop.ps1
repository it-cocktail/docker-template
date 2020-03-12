$PROJECTNAME = $envHash.PROJECTNAME
$ENVIRONMENT = $envHash.ENVIRONMENT

if ($envHash.MYSQL_PORT) {
    Parse-File "kubernetes/app/mysql-service.yaml" | kubectl delete -f -
}

Parse-File "kubernetes/ingress/app-ingress.yaml" | kubectl delete -f -
Parse-File "kubernetes/ingress/db-ingress.yaml" | kubectl delete -f -

if (Test-Path "kubernetes/app/app-service.$ENVIRONMENT.yaml") {
    Parse-File "kubernetes/app/app-service.$ENVIRONMENT.yaml" | kubectl delete -f -
} else {
    Parse-File "kubernetes/app/app-service.default.yaml" | kubectl delete -f -
}

if (Test-Path "kubernetes/app/db-service.$ENVIRONMENT.yaml") {
    Parse-File "kubernetes/app/db-service.$ENVIRONMENT.yaml" | kubectl delete -f -
} else {
    Parse-File "kubernetes/app/db-service.default.yaml" | kubectl delete -f -
}

kubectl delete secret "$PROJECTNAME-ssh"

if (Test-Path "kubernetes/configmaps/$ENVIRONMENT.yaml") {
    Parse-File "kubernetes/configmaps/$ENVIRONMENT.yaml" | kubectl delete -f -
} else {
    Parse-File "kubernetes/configmaps/default.yaml" | kubectl delete -f -
}

exit
