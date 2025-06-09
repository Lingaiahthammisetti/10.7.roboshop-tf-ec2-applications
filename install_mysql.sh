#!/bin/bash
dnf install mysql-server -y
systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation --set-root-pass RoboShop@1
systemctl restart mysqld
mysql -h mysql.lingaiah.online -uroot -pRoboShop@1