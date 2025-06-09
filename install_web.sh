#!/bin/bash

dnf install nginx -y 
systemctl enable nginx
systemctl start nginx
rm -rf /usr/share/nginx/html/*
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
cd /usr/share/nginx/html

unzip /tmp/web.zip

echo "
      proxy_http_version 1.1;
      location /images/ {
        expires 5s;
        root   /usr/share/nginx/html;
        try_files $uri /images/placeholder.jpg;
      }
      location /api/catalogue/ { proxy_pass http://catalogue.lingaiah.online:8080/; }
      location /api/user/ { proxy_pass http://user.lingaiah.online:8080/; }
      location /api/cart/ { proxy_pass http://cart.lingaiah.online:8080/; }
      location /api/shipping/ { proxy_pass http://shipping.lingaiah.online:8080/; }
      location /api/payment/ { proxy_pass http://payment.lingaiah.online:8080/; }

      location /health {
        stub_status on;
        access_log off;
      }"> /etc/nginx/default.d/roboshop.conf

systemctl restart nginx