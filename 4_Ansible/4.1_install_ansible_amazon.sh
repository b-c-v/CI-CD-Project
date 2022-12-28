#Description: Change hostname of the server and install Ansible and Docker on AmazonLinux

#change hostname of server
sudo hostnamectl set-hostname ansible

#!/bin/bash

#install Ansible
sudo amazon-linux-extras install ansible2


#install Docker
sudo amazon-linux-extras install ansible2
sudo yum install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service


