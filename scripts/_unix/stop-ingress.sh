#!/bin/sh

kubectl delete -f kubernetes/ingress/cloud-generic.yaml
kubectl delete -f kubernetes/ingress/mandatory.yaml

exit
