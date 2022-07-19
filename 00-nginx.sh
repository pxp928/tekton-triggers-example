#!/bin/bash

echo "Install tekton pipelines"
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

echo "Install tekton triggers"
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml

echo "Add cluster-admin permissions on the cluster for nginx ingress controller"
kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin \
  --user $(gcloud config get-value account)

echo "Add nginx ingress controller"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml

# For private clusters, you will need to either add an additional firewall rule that allows master nodes access to port 8443/tcp on worker nodes, 
# or change the existing rule that allows access to ports 80/tcp, 443/tcp and 10254/tcp to also allow access to port 8443/tcp.