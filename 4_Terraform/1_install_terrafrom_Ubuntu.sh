# Description: Iinstall packages on Ubuntu:
# * Terraform
# * AWS CLI

#!/bin/bash

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


#check versions of installed packeges
echo "            
===============================================
¯\_(ツ)_/¯     Installation completed     
==============================================="
echo "***************Terraform*****************"
terraform -version
echo "*******************AWS*******************"
aws --version


echo "Please enter your credentials to connect to AWS:"
aws configure