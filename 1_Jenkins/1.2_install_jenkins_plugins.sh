#!/bin/bash

# Description: Install Jenkins plugins

#Credentials
echo "Enter username: "
user=admin
# read user

echo "Enter token:"
token=11e0862ca3f0b7221cf6dc9738557b3843 # Manage Jenkins==>Manage Users==>user_name==>Configure==>API Token==>Add new token
# read token 

echo "Enter path to Jenkins-cle.jar file"
cli=/home/ser/jenkins-cli.jar
# read cli

#Array of plugin names to be installed
plugin_name=(
    git                   #https://plugins.jenkins.io/git/
    maven-plugin          #https://plugins.jenkins.io/maven-plugin/
    deploy                #https://plugins.jenkins.io/deploy/
)
#Loop for installing plugins
for i in ${!plugin_name[@]}; do
java -jar $cli -s http://localhost:8080/ -auth $user:$token install-plugin ${plugin_name[$i]}
done

#restart Jenkins
echo "            
===============================================
¯\_(ツ)_/¯       Restarting Jenkins     
==============================================="
java -jar $cli -s http://localhost:8080/ -auth $user:$token safe-restart

