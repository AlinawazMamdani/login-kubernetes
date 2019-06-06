# Micro-services CI Project
## Introduction
This project creates a secure login system with files setup for use in kubernetes, this document will explain how to get the project up and running as well as details about the system.
## Prerequisites
1. GCP account
2. Gmail account for authentication email
3. docker hub account
4. Files for each service - can be obtained [here](https://github.com/AlinawazMamdani/CI-project)


## System connectivity
![Diagram](https://github.com/AlinawazMamdani/login-kubernetes/blob/master/Drawing1.png)

The diagram above shows how each service connects to each other once they have been deployed, the bottom is the point where dependencies start. So mongo-service is only dependent on mongo whilst the gateway is dependent on everything.

## Instructions

### Part 1 - Setting up GCP
1. Firstly create a project on google cloud platform
2. Enter the cloudshell located in the top right 
3. Next we need to create the cluster for all the application to be deployed on the command below will show you how to do this, region parameter may be changed but nodes must be at least 2

`gcloud container clusters create examplename --region europe-north1 --num-nodes=2`

### Part 2 - Pushing services to dockerhub
With the files obtained in the prerquisites we need to make some changes before we push them to your dockerhub the fastest way to do this is to create a vm instance and then follow the instuctions

1. pull the prerequisite link using git
2. open the docker-compose file using vim
3. replace all instances of alinawazmamdani with your own dockerhub username. The quickest way of doing this is to run the following command 

`:%s/alinawazmamdani/YOUR_USERNAME/g`

4. Then push this project to your own git repo

### Part 3 - Setting up kubernetes files 
Changes will have to made to the deployments folder in each file the image needs to be changed so that it references your own docker repository

1. Once all deployments refer to your own docker repo some changes need to be made to the files
2. Email-service needs to be updated with a new email and password in the environment variables part of the deployment
3. For the next change we need to run the services in order to get the IP of the gateway to do this navigate to the services folder and run the following commands

`kubectl apply -f .`

This command runs all the services that allows the deployments to be connected to following this run 

`kubectl get services`

The external IP address should now be visible copy this 
4. Navigate to the deployments folder and open the authentication service replace the IP in the environment variables section with the coppied version
5. run `kubectl apply -f .` in the deployments folder, this runs all the deployments that will now communicate through the services previously deployed
6. Push this repo to your github

### Part 4 - Jenkins inital setup
Next we will deploy jenkins to manage the continous integration aspect of this project.
1. First navigate to the jenkins folder similarly we need to deploy all the files run `kubectl apply -f .`
2. Connect to the ip given by `kubectl get services` at port 8080 
3. Run `kubectl get pods` followed by `kubectl logs jenkins~` where jenkins~ is the full name shown in the first command
4.This should provide the initial admin password needed for jenkins
5. Continue setup as normal
6. click manage jenkins and global security then enable proxy compatability

### Part 5 - Jenkins docker setup
Next steps will detail how to give permissions to allow jenkins to use docker
1. In the cloud shell run `kubectl get pods`
2. describe the jenkins pod using the name given with `kubectl describe pod (jenkins)`
3. we need to record the containerID and node given by this command
4. View your cloud instances on the GCP platform and ssh into the vm which nodeip corresponds to the ip recorded previously
5. we need to enter the jenkins container as the root user to add permissions this is done by the following commands

 `docker exec -it -u root (containerID) bash`
 
  `groupdel docker`
  
  `groupadd -g 412 docker`
  
  `usermod -aG docker jenkins`
  
  
 6. exit the session and ssh back in and run 
 
 `docker restart (containerID)`
 #### Jenkins pipeline
 ![Diagram](https://github.com/AlinawazMamdani/login-kubernetes/blob/master/pipeline.png)
### Part 6 - Setup jenkins job
Now we need to create a jenkins job in order to update the project everytime a update is made in any of the microservices
1. Create a new jenkins freestyle job
2. Setup source control given the link to the github containing the microservices
3. add post build actions
`docker-compose build`

`docker compose push`

4. Now for each service that needs to be updated we need to an additional link to the code

`kubectl --record deployment.apps/[SERVICE_NAME] set image deployment.v1.apps/[SERVICE_NAME] [SERVICE_NAME]=docker.io/[YOUR_USERNAME]/[SERVICE_NAME]:v${BUILD_NUMBER}`

replicate this line for each of the services and clients along replacing [YOUR_USERNAME] with your docker id and [SERVICE_NAME] with each of the clients and services.


## Common issues

### Jenkins crumb issues
The issue will persist until you have enabled proxy compatability successfully keep retrying until the setting is enabled.
