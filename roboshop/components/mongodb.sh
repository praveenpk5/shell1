#!/bin/bash

status_check() {
 if [ $? -eq 0 ]; then
 echo -e "\e[32mSUCCESS\e[0m"
 else
 echo -e "\e[31mFAILURE\e[0m"
 exit 2
 fi
 } 
 
echo "Setting MongoDB"

echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
status_check $?


 echo "Installing MongoDB"
yum install -y mongodb-org &>>/tmp/log
status_check $?
 
echo "Config MongoDB"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf  
status_check $?

echo "starting MongoDB"
 systemctl enable mongod
 systemctl restart mongod
status_check $?
 
echo "Downloading MongoDB"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
status_check $?

cd /tmp
echo "extracting schema"
unzip -o mongodb.zip &>>/tmp/log
status_check $?

cd mongodb-main 
echo "Loading schema"
mongo < catalogue.js &>>/tmp/log
mongo < users.js &>>/tmp/log
status_check $?