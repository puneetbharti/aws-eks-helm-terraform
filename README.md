### Tools Used
* Terraform (v0.12.7)
* Shell 
* Helm (v2.14.1)
* Kubernetes (1.13)

### AWS Services Used 
* EKS (Elastic Kubernetes Service): It is a managed kubernetes service by AWS, which makes it easy to deploy and scale containerised applications on kubernetes. Basically master nodes are managed by aws which are distributed across multiple availability zones, which makes it highly available.
* ECR (Elastic Container Registry): It is a docker registry service managed by AWS, I have used it to push docker images after build, further these images pulled and deployed on kubernetes cluster.


### System Architecture

Since I have used EKS, it is highly available architecture distributed across all three zones in a private subnets.
EKS has managed master nodes and worker nodes were created using terraform scripts.

![Architecture Diagram](https://eks-k8s-demo-challenge-dev.s3.eu-central-1.amazonaws.com/eks-k8s-demo-System-Architecture.png)

As it can be seen on the above diagram, eks and worker nodes on private subnet and requests are served through loadbalancer.


### Deployment Pipeline

Deployment pipeline is pretty simple and straight.

![Deployment Pipeline](https://eks-k8s-demo-challenge-dev.s3.eu-central-1.amazonaws.com/eks-k8s-demo-Deployment-Pipeline-v1.png)

Here I am considering only one environment, which is a base environment, some people say it as a Dev environment. 

The deployment pipeline solution is git branch agnostic.

##### Pipeline Steps
* Developer pushes the code, since it is branch agnostic, developer can push to any branch.
* A webhook in github or in gitlab will trigger a jenkins build.
* Jenkins will pull the source code and has series of steps 
	* Build: Create a docker image with a tag, this tag will be jenkins BUILD_NUMBER
	* Push Image: This docker image is pushed to the ECR repository.
	* Integration Test: In this test we deploy the image on a different namespace and do the testing on that namespace.
	* If testing is successful it will deploy to release namespace else abort the deployment  

##### Rollback Procedure 
Rollback pretty simple using helm, there is a script called `rollback.sh`, which will display the history of deployments, where we can decide which deployment version needs to be rollback.

![Rollback](https://eks-k8s-demo-challenge-dev.s3.eu-central-1.amazonaws.com/rollback.png)

This is how rollback will look like when you execute `ci/rollback.sh`, it will show you the state of current deployment and after deployment. As it can be seen before rolling back docker image tag was 6 and after rolling back docker image tag is 4.



### System setup Instructions

##### Prerequisites 
* Docker 
* Kubernetes 
* awscli 
* helm
* terraform

##### Setting up Infrastructure 
Go to terraform directory, execute below command  

``` terraform plan ```

then execute 

``` terraform apply ```

this will prompt with yes or no 

Output will appear in some time, something like this 

```

Outputs:

registry_id = 04086xxxxxx
repository_url = 04086xxxxxx.dkr.ecr.eu-central-1.amazonaws.com/eks-k8s-demo-app
vpc_id = vpc-05dcda2dbe4ab8651
vpc_private_subnets = [
  "subnet-03b3f6f0fc6511f71",
  "subnet-0e5b4ac4778ecb904",
  "subnet-07b782764a974f92d",
]
vpc_public_ips = [
  "35.157.228.57",
  "18.195.40.173",
  "3.123.65.92",
]
vpc_public_subnets = [
  "subnet-0d2800896051542af",
  "subnet-00b49683c8ca28221",
  "subnet-0a153f42eb2af51a1",
]
```



##### Setting up local kubernetes environment 

1. Set kubernetes config  
   `aws eks --region eu-central-1 update-kubeconfig --name eks-k8s-demo-dev-cluster`
   Note: you need to be updated with awscli on local instance before running this command.
2. initialize helm 
	
	`helm init `
3. Login to ECR 

	`$(aws ecr get-login --no-include-email --region eu-central-1)`
		
4. Check worker nodes 

	`kubectl get nodes`

5. Set the ECR repository url as an environment variables 
   
   `export REPOSITORY_URL="<replace with ecr repo url>"`
   

##### Do the first deployment 
Please check if the environment variables are set properly 

`echo $REPOSITORY_URL`

Execute first script 

`sh ci/firsttime.sh`


##### Build Script 
This is main build script which can be used in jenkins pipeline 

`sh ci/build.sh <BUILD_NUMBER>`

`BUILD_NUMBER` is from jenkins build number.



### Further Improvements 
* Implimentation of multi environment deployment pipeline.
* Build pipeline should also have a step to generate a tag push it to the appliation repository, which will help us in tracking which part of code base is associated to docker build.
* Enabling Developers and QA to switch to versions depending on their requirements. Every individual can work on their respective environment whithout hampering others.
* Nginx or Kong API gateway, obviously there will be multiple services which needs to be put behind api gateway.
* Would like to put a better pipeline like groovy in jenkins or gitlab ci/cd.


### References 
[https://aws.amazon.com/quickstart/architecture/amazon-eks/](https://aws.amazon.com/quickstart/architecture/amazon-eks/)

[https://platform9.com/blog/kubernetes-helm-why-it-matters/](https://platform9.com/blog/kubernetes-helm-why-it-matters/)
