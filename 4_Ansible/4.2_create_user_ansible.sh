#Description: create user for password connection from Jenkins to Ansible (better use SSH-keys)

#!/bin/bash

#Credentials
echo "Enter username:"
read user

#add user with name ansiblecicd to system
sudo useradd $user

echo "Please enter a password for new user:"
sudo passwd $user

#add created user to group docker
sudo usermod -aG docker $user

#create directory for project and change owner of this directory to created user
sudo mkdir /opt/docker
sudo chown -R $user:$user /opt/docker/

#change permissions to file because during creating docker image will be error "Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: …"
sudo chmod 777 /var/run/docker.sock

#generate SSH-key for created user
su $user
ssh-keygen


echo "
*************************************************************************************************************************************
Don't forget to uncomment line 'PasswordAuthentication yes' and comment line 'PasswordAuthentication no' in file /etc/ssh/sshd_config
*************************************************************************************************************************************"
echo "File will open after 3 seconds"
sleep 3
sudo nano /etc/ssh/sshd_config

echo"
*************************************************************************************************************************************
Please add private IP addresses of this server and server with Docker to ansible hosts file
*************************************************************************************************************************************
[docker]
xxx.xxx.xxx.xxx
[ansible]
xxx.xxx.xxx.xxx
*************************************************************************************************************************************"
ip add
echo "File will open after three seconds"
sleep 3
sudo nano /etc/ansible/hosts

echo "
*************************************************************************************************************************************
In file find line:
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL

and add new line below (**username** is name of the user you just created):

**username** ALL=(ALL)   ALL
 
*************************************************************************************************************************************"
echo "File will open after 3 seconds"
sleep 3
sudo visudo

#restart SSH server
echo "Restart SSH server"
sudo service sshd reload

#exchange ssh-key with servers
sudo su ansiblecicd
#Credentials
echo "Enter IP address of server with Docker:"
read ip_docker
ssh-copy-id ip_docker

echo "Enter IP address of this server:"
read ip_localhost
ssh-copy-id ip_localhost

