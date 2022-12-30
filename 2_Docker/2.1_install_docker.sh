#Description: Change hostname of the server and install Docker on AmazonLinux

#!/bin/bash

#change hostname of server
sudo hostnamectl set-hostname docker

#install Docker
sudo yum update
sudo yum install docker -y

#Enable docker service at boot time
sudo systemctl enable docker.service
#Start the Docker
sudo systemctl start docker.service

#Check Docker version and status
echo "***************Docker status***************"
sudo systemctl status docker.service
echo "***************Docker version***************"
docker --version

#Add group membership for the default user so you can run all docker commands without using the sudo command
sudo usermod -aG docker $USER
newgrp docker