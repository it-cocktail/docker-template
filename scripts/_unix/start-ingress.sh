#!/bin/sh

kubectl apply -f kubernetes/ingress/mandatory.yaml
kubectl apply -f kubernetes/ingress/cloud-generic.yaml

exit
