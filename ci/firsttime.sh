#!/bin/bash
TAG=1
APP_DIR="${PWD}/../application"
APP_NAME="eks-k8s-demo-app"
ARTIFACTS_DIR="${PWD}/../artifacts"

###
### Building docker image for the first time
###
docker build -t ${REPOSITORY_URL}:${TAG} $APP_DIR
docker tag ${REPOSITORY_URL}:${TAG} ${REPOSITORY_URL}:latest
docker push ${REPOSITORY_URL}:latest
docker tag ${REPOSITORY_URL}:latest ${REPOSITORY_URL}:${TAG}
docker push ${REPOSITORY_URL}:${TAG}


###
### Creating namespace for first deployment 
###
kubectl apply -f $ARTIFACTS_DIR/eks-k8s-demo-namespace.yaml

###
### first deployment with helm
###

helm install ${ARTIFACTS_DIR}/${APP_NAME} --name ${APP_NAME} --namespace eks-k8s-demo --set image.repository=${REPOSITORY_URL},image.tag=${TAG}

###
### Check the deployment history 
### 
echo "Deployment history "
echo "--------------------"
helm history ${APP_NAME}
echo "--------------------"
echo "\n"
echo "--------------------"
echo "Load Balancer url "
echo "--------------------"
echo "http://"$(kubectl get svc --namespace eks-k8s-demo eks-k8s-demo-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "--------------------"
echo "\n"


###
### Check kubernetes deployment
### 
echo "--------------------"
kubectl get deployment -o wide -n eks-k8s-demo
echo "--------------------"
