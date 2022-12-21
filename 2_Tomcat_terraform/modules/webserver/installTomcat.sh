#!/bin/bash

#change hostname of instance
sudo hostnamectl set-hostname tomcat

#install java
sudo yum update –y
sudo amazon-linux-extras install java-openjdk11 -y

#install tomcat
sudo yum update -y
sudo yum install httpd -y