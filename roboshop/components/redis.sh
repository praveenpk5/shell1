#!/bin/bash

source components/common.sh

Print "install yum utils & download Redis Repos"
yum install epel-release yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>$LOG
Status_Check $?

Print "setup Redis Repos"
yum-config-manager --enable remi &>>$LOG
Status_Check $?
 
Print "install Redis"
yum install redis -y &>>$LOG
Status_Check $?

Print "configuration Redis listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf 
Status_Check $?

Print "Start Redis service"
systemctl enable redis &>>$LOG && systemctl start redis &>>$LOG
Status_Check $?