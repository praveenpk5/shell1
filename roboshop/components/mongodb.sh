#!/usr/bin/bash

source components/common.sh

Print "Setting MongoDB"

echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
Status_Check $?

Print "Installing MongoDB"
yum install -y mongodb-org &>>$LOG
Status_Check $?
 
Print "Config MongoDB\t"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf  
Status_Check $?

Print "starting MongoDB"
 systemctl enable mongod
 systemctl restart mongod
Status_Check $?
 
Print "Downloading MongoDB"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
Status_Check $?

cd /tmp
Print "extracting schema"
unzip -o mongodb.zip &>>$LOG
Status_Check $?

cd mongodb-main 
Print "Loading schema\t"
mongo < catalogue.js &>>$LOG
mongo < users.js &>>$LOG
Status_Check $?

exit 0

