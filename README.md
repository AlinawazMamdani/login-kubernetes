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
