#!/bin/sh

$KUBECTLCMD delete -f kubernetes/ingress/cloud-generic.yaml
$KUBECTLCMD delete -f kubernetes/ingress/mandatory.yaml

exit
