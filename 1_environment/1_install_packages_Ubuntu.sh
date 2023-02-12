# Description: Install packages on Ubuntu:
# * Ansible
# * Jenkins
# * Git
# * Terraform
# * AWS CLI

#!/bin/bash

# install Ansible
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
ansible --version

# install Jenkins
sudo apt update
sudo apt install -y curl
sudo apt install -y openjdk-11-jre
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc >/dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list >/dev/null
sudo apt-get -y update
sudo apt-get -y install jenkins
sudo systemctl enable jenkins # Enable the Jenkins service to start at boot
sudo systemctl start jenkins  # Start Jenkins as a service
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

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
echo "***************Terraform*****************"
ansible --version
echo "***************Terraform*****************"
jenkins --version
echo "***************Terraform*****************"
git -version
echo "***************Terraform*****************"
terraform -version
echo "*******************AWS*******************"
aws --version

echo "Please enter your credentials to connect to AWS:"
aws configure
