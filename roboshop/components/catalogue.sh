#!/usr/bin/bash

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

Print "Downloading catalogue content"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
Status_Check $?

Print "extracting catalogue\t"
cd /home/roboshop
rm -rf catalogue && unzip -o /tmp/catalogue.zip &>>$LOG && mv catalogue-main catalogue
Status_Check $?

Print "Download NodeJS Dependencies"
cd /home/roboshop/catalogue
npm install --unsafe-perm &>>$LOG
Status_Check $?

chown roboshop:roboshop -R /home/roboshop

Print "update systemd service\t"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.int/' /home/roboshop/catalogue/systemd.service
Status_Check $?

Print "setup systemd service\t"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service && systemctl daemon-reload && systemctl start catalogue &>>$LOG && systemctl enable catalogue &>>$LOG
Status_Check $?