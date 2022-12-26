#Description: create user for password connection from Jenkins (better use SSH-keys)

#!/bin/bash

#Credentials
echo "Enter username:"
read user

#add user wiht name dockercicd to system
sudo useradd $user

#add created user to group docker
sudo usermod -aG docker $user

echo "Please enter a password for new user:"
sudo passwd $user

echo "
*************************************************************************************************************************************
Don't forget to uncomment line 'PasswordAuthentication yes' and comment line 'PasswordAuthentication no' in file /etc/ssh/sshd_config
*************************************************************************************************************************************"
echo "File will open after 3 seconds"
sleep 3
sudo nano /etc/ssh/sshd_config

#restart SSH server
echo "Restart SSH server"
sudo service sshd reload
