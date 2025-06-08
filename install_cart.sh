#!/bin/bash

dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y

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

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip
npm install

echo "[Unit]
Description = Cart Service
[Service]
User=roboshop
Environment=REDIS_HOST=redis.lingaiah.online
Environment=CATALOGUE_HOST=catalogue.lingaiah.online
Environment=CATALOGUE_PORT=8080
ExecStart=/bin/node /app/server.js
SyslogIdentifier=cart

[Install]
WantedBy=multi-user.target"> /etc/systemd/system/cart.service

systemctl daemon-reload
systemctl enable cart
systemctl start cart