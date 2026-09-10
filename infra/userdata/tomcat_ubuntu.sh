#!/bin/bash
hostnamectl set-hostname app01.vprofile.in
sudo apt update -y
sudo apt upgrade -y
sudo apt install openjdk-17-jdk -y
sudo apt install tomcat10 tomcat10-admin tomcat10-docs tomcat10-common git -y
sudo snap install aws-cli --classic
sudo systemctl enable tomcat10
sudo systemctl start tomcat10
