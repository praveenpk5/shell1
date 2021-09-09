#!/bin/bash

source components/common.sh

print "installing NodeJS"
yum install nodejs make gcc-c++ -y  &>>$LOG
status_check $?

print "Adding Roboshop User"
useradd roboshop &>>$LOG

print "Downloading catalogue content"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
status_check $?


cd /home/roboshop
unzip /tmp/catalogue.zip &>>$LOG
mv catalogue-main catalogue
status_check $?

cd /home/roboshop/catalogue
npm install &>>$LOG


# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue