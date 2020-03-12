Invoke-Expression "kubectl apply -f kubernetes/ingress/mandatory.yaml"
Invoke-Expression "kubectl apply -f kubernetes/ingress/cloud-generic.yaml"

exit
