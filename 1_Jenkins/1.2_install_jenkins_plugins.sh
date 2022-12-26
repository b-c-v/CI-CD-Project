# Description: Install plugins in Jenkins

#!/bin/bash

#Credentials
echo "Enter username: "
read user

echo "Enter token:" # Manage Jenkins==>Manage Users==>user_name==>Configure==>API Token==>Add new token
read token 

#copy Jenkins-cle.jar file to current directory"
wget -nc http://localhost:8080/jnlpJars/jenkins-cli.jar #-nc  skip downloads that would download to existing files ()

#Array of plugin names to be installed
plugin_name=(
    git                   #https://plugins.jenkins.io/git/
    github                #https://plugins.jenkins.io/github/
    maven-plugin          #https://plugins.jenkins.io/maven-plugin/
    deploy                #https://plugins.jenkins.io/deploy/
    publish-over-ssh      #https://plugins.jenkins.io/publish-over-ssh/ (use for Docker)
)

#Loop for installing plugins
for i in ${!plugin_name[@]}; do
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth $user:$token install-plugin ${plugin_name[$i]}
done

#restart Jenkins
echo "            
===============================================
¯\_(ツ)_/¯       Restarting Jenkins     
==============================================="
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth $user:$token safe-restart

