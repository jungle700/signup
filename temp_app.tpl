#!/bin/bash

 yum update -y

 yum install git -y

 wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo

 rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

 yum install jenkins -y

 yum install java-1.8.0-openjdk -y

 service jenkins start

 yum install python-pip -y

 pip install flask

 git clone https://github.com/jungle700/june2020_singup_project.git

 cd june2020_singup_project

 pip install -r requirements.txt

 

export AWS_ACCESS_KEY_ID=

export AWS_SECRET_ACCESS_KEY=


 
 FLASK_APP=application.py AWS_REGION=eu-west-1 STARTUP_SIGNUP_TABLE=flex-db NEW_SIGNUP_TOPIC=arn:aws:sns:eu-west-1:941743414580:Signup-test flask run --host 0.0.0.0