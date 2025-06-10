#!/bin/bash

echo "[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc" > /etc/yum.repos.d/mongo.repo

dnf install mongodb-org -y
systemctl enable mongod
systemctl start mongod

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

systemctl restart mongod


echo "***************************************"
sudo systemctl status mongod
echo "***************************************"
netstat -lntp
echo "***************************************"