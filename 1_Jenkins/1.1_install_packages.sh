# # Description: Setting up packages to server:
# * Jenkins
# * GIT
# * Maven
# * Terraform
# * AWS

#!/bin/bash

#install curl
sudo apt update
sudo apt install -y curl

#install java
sudo apt install -y openjdk-11-jre

#install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get -y update
sudo apt-get -y install jenkins 

#install git
sudo apt install -y git

#instal maven v3.8.6
sudo apt install -y maven

#install terraform
curl https://releases.hashicorp.com/terraform/1.3.6/terraform_1.3.6_linux_amd64.zip -o terraform.zip
unzip terraform.zip
sudo mv terraform /bin/
rm terraform.zip

#install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -r aws*

#change hostname of server
sudo hostnamectl set-hostname jenkins
#reboot system for changing hostname name
sudo reboot

#check versions of installed packeges
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
echo "***************Terraform*****************"
terraform --version
echo "*****************Jenkins*****************"
jenkins --version
echo "*******************AWS*******************"
aws --version
echo "*************Jenkins Password************"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

sleep 3