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

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
npm install

echo "[Unit]
Description = User Service
[Service]
User=roboshop
Environment=MONGO=true
Environment=REDIS_HOST=redis.lingaiah.online
Environment=MONGO_URL="mongodb://mongodb.lingaiah.online:27017/users"
ExecStart=/bin/node /app/server.js
SyslogIdentifier=user

[Install]
WantedBy=multi-user.target"> /etc/systemd/system/user.service

systemctl daemon-reload
systemctl enable user
systemctl start user

echo " [mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc"> /etc/yum.repos.d/mongo.repo

dnf install -y mongodb-mongosh

SCHEMA_EXISTS=$(mongosh --host $MONGO_HOST --quiet --eval "db.getMongo().getDBNames().indexOf('users')")

if [ $SCHEMA_EXISTS -lt 0 ]
then
    echo "Schema does not exists ... LOADING"
    mongosh --host $MONGO_HOST </app/schema/user.js
    echo  "Loading user data"
else
    echo "schema already exists."
fi

echo "***************************************"
sudo systemctl status user
echo "***************************************"
netstat -lntp
echo "***************************************"