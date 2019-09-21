#!/bin/bash

#set -ex

TAG=${1?:"Missing parameter TAG number"}


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
### Function to initiate deployment
###
function do_deployment
{
kubectl apply -f $ARTIFACTS_DIR/eks-k8s-demo-namespace.yaml
helm upgrade  ${APP_NAME} ${ARTIFACTS_DIR}/${APP_NAME} --set image.repository=${REPOSITORY_URL},image.tag=${TAG}
echo "Deployment history "
echo "--------------------"
helm history ${APP_NAME}
echo "--------------------"
echo "\n"
echo "--------------------"
echo "Load Balancer url for testing"
echo "--------------------"
echo "http://"$(kubectl get svc --namespace eks-k8s-demo eks-k8s-demo-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "--------------------"
echo "\n"
}

###
### Function to abort deployment
###
function abort_deployment
{
 echo "Integration test failed.. Aborting.."
}

###
### Function to delete test deployment 
###
function delete_test_deployment
{
  echo "deleting test deployment"
  helm del --purge ${APP_NAME}-test
}

###
### Integration test after creating build
###
### Once build is created, before deploying to main running namespace, deploy to test name space

echo "Begin Integration Test "
echo "--------------------"
kubectl apply -f $ARTIFACTS_DIR/integration-test-namespace.yaml
helm install ${ARTIFACTS_DIR}/${APP_NAME} --name ${APP_NAME}-test --namespace integration-test --set image.repository=${REPOSITORY_URL},image.tag=${TAG}
INTEGRATION_TEST_URL="http://$(kubectl get svc --namespace integration-test ${APP_NAME}-test -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')"
echo "--------------------"
echo "Integration test url"
echo "--------------------"
echo $INTEGRATION_TEST_URL
echo "--------------------"

###
### Just a simple integration test for demo
### If the build number is odd then build will fail else build would be successful 
###
if [ `echo "${TAG} % 2" | bc` -eq 0 ]
then 
  echo "Integration test passed "
  delete_test_deployment
  do_deployment
else 
  echo "odd"
  delete_test_deployment
  abort_deployment
  
fi










