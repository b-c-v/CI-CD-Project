# Description: Install packages on AmazonLinux server:
# * Jenkins
# * GIT
# * Maven
# * Terraform

#!/bin/bash

#install Jenkins
sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo #Add the Jenkins repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key #Import a key file from Jenkins-CI to enable installation from the package:
sudo yum upgrade
sudo amazon-linux-extras install java-openjdk11 -y #Install Java
sudo yum install jenkins -y #Install Jenkins
sudo systemctl enable jenkins # Enable the Jenkins service to start at boot
sudo systemctl start jenkins # Start Jenkins as a service


#install git
sudo yum install -y git

#instal maven v3.8.6
sudo yum install -y maven

#install terraform
curl https://releases.hashicorp.com/terraform/1.3.6/terraform_1.3.6_linux_amd64.zip -o terraform.zip
unzip terraform.zip
sudo mv terraform /bin/
rm terraform.zip

#change hostname of server
sudo hostnamectl set-hostname jenkins