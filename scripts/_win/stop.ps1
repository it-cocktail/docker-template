Parse-File "kubernetes/app/db-ingress.yaml" | kubectl apply -f -
Parse-File "kubernetes/app/db-service.yaml" | kubectl apply -f -

Parse-File "kubernetes/app/app-ingress.yaml" | kubectl apply -f -
Parse-File "kubernetes/app/app-service.yaml" | kubectl apply -f -

Parse-File "kubernetes/volumes/htdocs.yaml" | kubectl apply -f -
Parse-File "kubernetes/volumes/container.yaml" | kubectl apply -f -

$environment = $envHash['ENVIRONMENT']
Parse-File "kubernetes/configmaps/$environment.yaml" | kubectl apply -f -

exit
