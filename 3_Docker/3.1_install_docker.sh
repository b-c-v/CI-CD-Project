#Description: Install Docker on AmazonLinux server

#!/bin/bash
sudo yum update
sudo yum install docker -y

#Add group membership for the default user so you can run all docker commands without using the sudo command
sudo usermod -aG docker $USER
newgrp docker


#Enable docker service at boot time
sudo systemctl enable docker.service
#Start the Docker
sudo systemctl start docker.service

#Check Docker version and status
echo "***************Docker status***************"
sudo systemctl status docker.service
echo "***************Docker version***************"
docker --version