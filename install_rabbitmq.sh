#!/bin/bash

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

dnf install rabbitmq-server -y
systemctl enable rabbitmq-server  
systemctl start rabbitmq-server

rabbitmqctl add_user roboshop roboshop123
sudo rabbitmqctl list_users | grep roboshop 
if [ $? -ne 0 ]
then
    rabbitmqctl add_user roboshop roboshop123 
    echo "Adding RabbitMQ user"
    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
    echo "Setting permissions"
else
    echo "USER already exists."
fi