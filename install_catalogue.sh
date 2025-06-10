#!/bin/bash

dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y

MONGO_HOST=mongodb.lingaiah.online

id roboshop 
if [ $? -ne 0 ]
then
    useradd roboshop 
    echo "Adding roboshop user"
else
    echo "roboshop user already exist."
fi

rm -rf /app 

mkdir -p /app

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
npm install

echo "[Unit]
Description = Catalogue Service

[Service]
User=roboshop
Environment=MONGO=true
Environment=MONGO_URL="mongodb://mongodb.lingaiah.online:27017/catalogue"
ExecStart=/bin/node /app/server.js
SyslogIdentifier=catalogue

[Install]
WantedBy=multi-user.target"> /etc/systemd/system/catalogue.service

systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue


echo "[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc"> /etc/yum.repos.d/mongo.repo

dnf install -y mongodb-mongosh

SCHEMA_EXISTS=$(mongosh --host $MONGO_HOST --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')") 

if [ $SCHEMA_EXISTS -lt 0 ]
then
    echo "Schema does not exists ... LOADING"
    mongosh --host $MONGO_HOST </app/schema/catalogue.js 
    echo "Loading catalogue data"
else
    echo "schema already exists."
fi

echo "***************************************"
sudo systemctl status catalogue
echo "***************************************"
netstat -lntp
echo "***************************************"