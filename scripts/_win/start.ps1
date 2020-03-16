$PROJECTNAME = $envHash.PROJECTNAME
$ENVIRONMENT = $envHash.ENVIRONMENT

Parse-File "kubernetes/namespace.yaml" | kubectl apply -f -

if (Test-Path "kubernetes/configmaps/$ENVIRONMENT.yaml") {
    Parse-File "kubernetes/configmaps/$ENVIRONMENT.yaml" | kubectl apply -f -
} else {
    Parse-File "kubernetes/configmaps/default.yaml" | kubectl apply -f -
}

if (Test-Path "$HOME/.ssh/id_rsa") {
    kubectl create secret generic "ssh" -n "$PROJECTNAME" --from-file = $HOME/.ssh/id_rsa.pub --from-file =$HOME/.ssh/id_rsa
}

if (Test-Path "kubernetes/app/db-service.$ENVIRONMENT.yaml") {
    Parse-File "kubernetes/app/db-service.$ENVIRONMENT.yaml" | kubectl apply -f -
} else {
    Parse-File "kubernetes/app/db-service.default.yaml" | kubectl apply -f -
}

if (Test-Path "kubernetes/app/app-service.$ENVIRONMENT.yaml") {
    Parse-File "kubernetes/app/app-service.$ENVIRONMENT.yaml" | kubectl apply -f -
} else {
    Parse-File "kubernetes/app/app-service.default.yaml" | kubectl apply -f -
}

if (Test-Path "kubernetes/app/db-ingress.$ENVIRONMENT.yaml") {
    Parse-File "kubernetes/app/db-ingress.$ENVIRONMENT.yaml" | kubectl apply -f -
} else {
    Parse-File "kubernetes/app/db-ingress.default.yaml" | kubectl apply -f -
}

if (Test-Path "kubernetes/app/app-ingress.$ENVIRONMENT.yaml") {
    Parse-File "kubernetes/app/app-ingress.$ENVIRONMENT.yaml" | kubectl apply -f -
} else {
    Parse-File "kubernetes/app/app-ingress.default.yaml" | kubectl apply -f -
}

if ($envHash.MYSQL_PORT) {
    Parse-File "kubernetes/app/mysql-service.yaml" | kubectl apply -f -
}
exit
