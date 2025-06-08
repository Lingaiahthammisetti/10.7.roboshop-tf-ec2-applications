#!/bin/bash

dnf install python3.11 gcc python3-devel -y 

id roboshop &>> 
if [ $? -ne 0 ]
then
    useradd roboshop
    echo "Adding roboshop user"
else
    echo "roboshop user already exist."
fi

rm -rf /app 
mkdir -p /app 
curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip 
cd /app  
unzip /tmp/payment.zip 
pip3.11 install -r requirements.txt 

echo "[Unit]
Description=Payment Service

[Service]
User=root
WorkingDirectory=/app
Environment=CART_HOST=cart.lingaiah.online
Environment=CART_PORT=8080
Environment=USER_HOST=user.lingaiah.online
Environment=USER_PORT=8080
Environment=AMQP_HOST=rabbitmq.lingaiah.online
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123

ExecStart=/usr/local/bin/uwsgi --ini payment.ini
ExecStop=/bin/kill -9 $MAINPID
SyslogIdentifier=payment

[Install]
WantedBy=multi-user.target"> /etc/systemd/system/payment.service

systemctl daemon-reload 
systemctl enable payment 
systemctl start payment 