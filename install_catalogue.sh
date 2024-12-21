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

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
npm install

echo " [Unit]
Description = Catalogue Service

[Service]
User=roboshop
Environment=MONGO=true
Environment=MONGO_URL="mongodb://mongodb.lingaiah.online:27017/catalogue"
ExecStart=/bin/node /app/server.js
SyslogIdentifier=catalogue

[Install]
WantedBy=multi-user.target " > /etc/systemd/system/catalogue.service

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