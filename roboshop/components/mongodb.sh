echo "setting MongoDB"

echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo

echo "installing MongoDB"
yum install -y mongodb-org &>>/tmp/log

echo "config MongoDB"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf  


echo "starting MongoDB"
 systemctl enable mongod
 systemctl restart mongod

echo "downloading MongoDB"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"

cd /tmp
unzip -o mongodb.zip &>>/tmp/log
cd mongodb-main 
echo "loading schema"
mongo < catalogue.js &>>/tmp/log
mongo < users.js &>>/tmp/log