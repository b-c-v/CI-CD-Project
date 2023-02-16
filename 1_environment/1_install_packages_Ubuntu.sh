# Description: Install packages on Ubuntu:
# * Ansible
# * Jenkins
# * Git
# * Terraform
# * AWS CLI

#!/bin/bash

# install Ansible
sudo apt update -y
sudo apt install ansible -y

# install Jenkins
sudo apt update -y
sudo apt install -y curl
sudo apt install -y openjdk-11-jre
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc >/dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list >/dev/null
sudo apt-get -y update
sudo apt-get -y install jenkins
sudo systemctl enable jenkins # Enable the Jenkins service to start at boot
sudo systemctl start jenkins  # Start Jenkins as a service

#install plugins Jenkins
token=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
wget -nc http://localhost:8080/jnlpJars/jenkins-cli.jar #-nc  skip downloads that would download to existing files ()

plugin_name=(#Array of plugin names to be installed
    terraform           #https://plugins.jenkins.io/terraform/
    workflow-aggregator #pipeline https://plugins.jenkins.io/workflow-aggregator/
    git                 #https://plugins.jenkins.io/git/
    github              #https://plugins.jenkins.io/github/
    ansible             #https://plugins.jenkins.io/ansible/
    ansicolor           #https://plugins.jenkins.io/ansicolor/
    aws-credentials     #https://plugins.jenkins.io/aws-credentials/
)

for i in ${!plugin_name[@]}; do #Loop for installing plugins
    java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:$token install-plugin ${plugin_name[$i]}
done
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:$token safe-restart
rm jenkins-cli.jar

# install Git
sudo apt install git -y

# install Terraform
curl https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_amd64.zip -o terraform.zip
unzip terraform.zip
sudo mv terraform /bin/
rm terraform.zip

# install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -r aws*

# check versions of installed packages
echo "            
===============================================
¯\_(ツ)_/¯     Installation completed     
==============================================="
echo "****************Ansible******************"
ansible --version
echo "****************Jenkins******************"
jenkins --version
echo "*********Your Jenkins Password***********"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "******************Git********************"
git --version
echo "***************Terraform*****************"
terraform -version
echo "*******************AWS*******************"
aws --version

# echo "Please enter your credentials to connect to AWS:" don't required because use module Jenkins. Check!
# aws configure
