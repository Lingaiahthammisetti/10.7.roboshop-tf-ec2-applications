#!/bin/bash

dnf install redis -y
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf 
systemctl enable redis
systemctl start redis

echo "***************************************"
sudo systemctl status redis
echo "***************************************"
netstat -lntp
echo "***************************************"