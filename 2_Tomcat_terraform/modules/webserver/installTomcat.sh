#Description: Install Tomcat on AmazonLinux server

#!/bin/bash

#change hostname of instance
sudo hostnamectl set-hostname tomcat

#install java
sudo yum update –y
sudo amazon-linux-extras install java-openjdk11 -y

#install Tomcat
cd /opt/
sudo wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.27/bin/apache-tomcat-10.0.27.tar.gz
sudo tar -xzf apache-tomcat-10.0.27.tar.gz
sudo mv apache-tomcat-10.0.27 tomcat
sudo rm apache-tomcat-10.0.27.tar.gz

#run Tomcat
cd /opt/tomcat/bin && ./startup.sh