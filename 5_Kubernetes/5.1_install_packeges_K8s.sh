#Description: Change hostname of the server and install AWS CLI, kubectl, eksctl

#!/bin/bash

# change hostname of server
sudo hostnamectl set-hostname k8s

# install last version of AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# install kubectl

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.7/2022-10-31/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >>~/.bashrc

# install eksctl

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl $HOME/bin/

#check versions of installed packages
echo "            
===============================================
¯\_(ツ)_/¯     Installation completed     
==============================================="
echo "*****************EKSCTL******************"
eksctl version
echo "*****************KUBECTL*****************"
kubectl version --short --client
echo "*****************AWS CLI*****************"
aws --version
