#!/bin/bash

dnf install maven -y 

MYSQL_HOST=mysql.lingaiah.online

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
curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip 
cd /app  
unzip /tmp/shipping.zip 
mvn clean package 
mv target/shipping-1.0.jar shipping.jar 

echo "[Unit]
Description=Shipping Service

[Service]
User=roboshop
Environment=CART_ENDPOINT=cart.lingaiah.online:8080
Environment=DB_HOST=mysql.lingaiah.online
ExecStart=/bin/java -jar /app/shipping.jar
SyslogIdentifier=shipping

[Install]
WantedBy=multi-user.target"> /etc/systemd/system/shipping.service 

systemctl daemon-reload 

systemctl enable shipping  

systemctl start shipping 

dnf install mysql -y 

mysql -h mysql.lingaiah.online -uroot -pRoboShop@1 -e "use cities"
if [ $? -ne 0 ]
then
    echo "Schema is ... LOADING"
    mysql -h mysql.lingaiah.online -uroot -pRoboShop@1 < /app/db/schema.sql
    
    mysql -h mysql.lingaiah.online -uroot -pRoboShop@1 < /app/db/app-user.sql
   
    mysql -h mysql.lingaiah.online -uroot -pRoboShop@1 < /app/db/master-data.sql
else
    echo "Schema already exists..."
fi

systemctl restart shipping

echo "***************************************"
sudo systemctl status shipping
echo "***************************************"
netstat -lntp
echo "***************************************"