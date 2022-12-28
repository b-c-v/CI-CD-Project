#Description: create user for password connection from Ansible-server (better use SSH-keys)

#!/bin/bash

#Credentials
echo "Enter username:"
read user

#add user with name ansiblecicd to system
sudo useradd $user

echo "Please enter a password for new user:"
sudo passwd $user

#change permissions to file because during creating docker image will be error "Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: …"
sudo chmod 777 /var/run/docker.sock

echo "
*************************************************************************************************************************************
Don't forget to uncomment line 'PasswordAuthentication yes' and comment line 'PasswordAuthentication no' in file /etc/ssh/sshd_config
*************************************************************************************************************************************"
echo "File will open after 3 seconds"
sleep 3
sudo nano /etc/ssh/sshd_config


echo "
*************************************************************************************************************************************
In file find line:
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL

and add new line (**username** is name of the user you just created):

**username** ALL=(ALL)   ALL

*************************************************************************************************************************************"
echo "File will open after 3 seconds"
sleep 3
sudo visudo

#restart SSH server
echo "Restart SSH server"
sudo service sshd reload




