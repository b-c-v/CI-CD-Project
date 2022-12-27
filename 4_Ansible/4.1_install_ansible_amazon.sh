#Description: Change hostname of the server and install Ansible and Docker on AmazonLinux

#change hostname of server
sudo hostnamectl set-hostname ansible

#!/bin/bash

#inatall Ansible
sudo amazon-linux-extras install ansible2



