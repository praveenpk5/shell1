#!/bin/bash

source components/common.sh

Print "installing NodeJS\t"
yum install nodejs make gcc-c++ -y &>>$LOG
Status_Check $?

Print "Adding Roboshop User\t"
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
 echo "user already there, so skipping" &>>$LOG
 else
useradd roboshop &>>$LOG
fi
Status_Check $?

Print "Downloading catalogue content\t"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
Status_Check $?

Print "extracting catalogue"
cd /home/roboshop
unzip /tmp/catalogue.zip &>>$LOG
mv catalogue-main catalogue
Status_Check $?

Print "Download NodeJS Dependencies"
cd /home/roboshop/catalogue
npm install &>>$LOG

chown roboshop:roboshop -R /home/roboshop

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue