#!/bin/sh

$KUBECTLCMD apply -f kubernetes/ingress/mandatory.yaml
$KUBECTLCMD apply -f kubernetes/ingress/cloud-generic.yaml

exit
