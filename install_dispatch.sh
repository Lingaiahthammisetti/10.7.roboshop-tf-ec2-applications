dnf install golang -y 
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
curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip 

cd /app 
unzip /tmp/dispatch.zip 
go mod init dispatch
go get 
go build 

echo "[Unit]
Description = Dispatch Service
[Service]
User=roboshop
Environment=AMQP_HOST=rabbitmq.lingaiah.online
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123
ExecStart=/app/dispatch
SyslogIdentifier=dispatch

[Install]
WantedBy=multi-user.target"> /etc/systemd/system/dispatch.service 

systemctl daemon-reload
systemctl enable dispatch 
systemctl start dispatch  