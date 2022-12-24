#!/bin/bash

# Description: Install Jenkins plugins

#Credentials
echo "Enter username: "
read user

echo "Enter token:" # Manage Jenkins==>Manage Users==>user_name==>Configure==>API Token==>Add new token
read token 

#copy Jenkins-cle.jar file to current directory"
wget http://localhost:8080/jnlpJars/jenkins-cli.jar

#Array of plugin names to be installed
plugin_name=(
    git                   #https://plugins.jenkins.io/git/
    maven-plugin          #https://plugins.jenkins.io/maven-plugin/
    deploy                #https://plugins.jenkins.io/deploy/
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

