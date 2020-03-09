$environment = $envHash['ENVIRONMENT']

if (Test-Path "kubernetes/configmaps/$environment.yaml") {
    Parse-File "kubernetes/configmaps/$environment.yaml" | kubectl apply -f -
} else {
    Parse-File "kubernetes/configmaps/default.yaml" | kubectl apply -f -
}

if (Test-Path "kubernetes/app/db-service.$environment.yaml") {
    Parse-File "kubernetes/app/db-service.$environment.yaml" | kubectl apply -f -
} else {
    Parse-File "kubernetes/app/db-service.default.yaml" | kubectl apply -f -
}

if (Test-Path "kubernetes/app/app-service.$environment.yaml") {
    Parse-File "kubernetes/app/app-service.$environment.yaml" | kubectl apply -f -
} else {
    Parse-File "kubernetes/app/app-service.default.yaml" | kubectl apply -f -
}

Parse-File "kubernetes/ingress/db-ingress.yaml" | kubectl apply -f -
Parse-File "kubernetes/ingress/app-ingress.yaml" | kubectl apply -f -

exit
