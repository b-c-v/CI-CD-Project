#!/bin/bash

#change hostname of instance
hostnamectl set-hostname tomcat

#install java
yum update –y
amazon-linux-extras install java-openjdk11 -y

#install tomcat
yum update -y
yum install httpd -y