#!/bin/bash

#REVISION=${1?:"Missing parameter TAG number"}

APP_NAME="eks-k8s-demo-app"

echo "-----------------"
echo "Before Rollback: Deployed Image Version"
echo "-----------------"
kubectl get deployments -o wide -n eks-k8s-demo
echo "-----------------"

echo "-----------------"
echo "Before Rollback: Deployment History"
echo "-----------------"
helm history ${APP_NAME}
echo "-----------------"


read -p "Please provide revision to rollback : " REVISION

echo "Rolling Back to ${REVISION} ............."
helm rollback ${APP_NAME} ${REVISION}
echo "-----------------"

echo "\n"
echo "-----------------"
echo "After Rollback: Deployed Image Version"
echo "-----------------"
kubectl get deployments -o wide -n eks-k8s-demo
echo "-----------------"
echo "\n"

echo "-----------------"
echo "After Rollback: Deployment History"
echo "-----------------"
helm history ${APP_NAME}
echo "-----------------"


