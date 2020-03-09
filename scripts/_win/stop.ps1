$environment = $envHash['ENVIRONMENT']

Parse-File "kubernetes/ingress/app-ingress.yaml" | kubectl delete -f -
Parse-File "kubernetes/ingress/db-ingress.yaml" | kubectl delete -f -

if (Test-Path "kubernetes/app/app-service.$environment.yaml") {
    Parse-File "kubernetes/app/app-service.$environment.yaml" | kubectl delete -f -
} else {
    Parse-File "kubernetes/app/app-service.default.yaml" | kubectl delete -f -
}

if (Test-Path "kubernetes/app/db-service.$environment.yaml") {
    Parse-File "kubernetes/app/db-service.$environment.yaml" | kubectl delete -f -
} else {
    Parse-File "kubernetes/app/db-service.default.yaml" | kubectl delete -f -
}

if (Test-Path "kubernetes/configmaps/$environment.yaml") {
    Parse-File "kubernetes/configmaps/$environment.yaml" | kubectl delete -f -
} else {
    Parse-File "kubernetes/configmaps/default.yaml" | kubectl delete -f -
}

exit
