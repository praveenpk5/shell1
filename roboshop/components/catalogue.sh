#!/bin/bash

source components/common.sh

print "installing NodeJS"
yum install nodejs make gcc-c++ -y &>>$LOG
status_check $?

print "Adding Roboshop User"
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
 echo "user already there, so skipping" &>>$LOG
 else
useradd roboshop &>>$LOG
fi
status_check $?

print "Downloading catalogue content"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
status_check $?

print "extracting catalogue"
cd /home/roboshop
unzip /tmp/catalogue.zip &>>$LOG
mv catalogue-main catalogue
status_check $?

print "Download NodeJS Dependencies"
cd /home/roboshop/catalogue
npm install &>>$LOG

chown roboshop:roboshop -R /home/roboshop

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue