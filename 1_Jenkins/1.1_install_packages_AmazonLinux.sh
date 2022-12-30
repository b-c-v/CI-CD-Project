# Description: Change hostname of the server and install packages on AmazonLinux:
# * Jenkins
# * GIT
# * Maven
# * Terraform

#!/bin/bash

#change hostname of server
sudo hostnamectl set-hostname jenkins

#install Jenkins
sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo #Add the Jenkins repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key #Import a key file from Jenkins-CI to enable installation from the package:
sudo yum upgrade
sudo amazon-linux-extras install java-openjdk11 -y #Install Java
sudo yum install jenkins -y #Install Jenkins
sudo systemctl enable jenkins # Enable the Jenkins service to start at boot
sudo systemctl start jenkins # Start Jenkins as a service


#install Git
sudo yum install -y git

#instal Maven
sudo yum install -y maven

#check versions of installed packages
echo "            
===============================================
¯\_(ツ)_/¯     Installation completed     
==============================================="
echo "******************JAVA*******************"
java --version
echo "*******************GIT*******************"
git --version
echo "******************MAVEN******************"
mvn --version
echo "*****************Jenkins*****************"
jenkins --version
echo "*******************AWS*******************"
aws --version
echo "*************Jenkins Password************"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword