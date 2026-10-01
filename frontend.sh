#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"

mkdir -p $LOGS_FOLDER        

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo -e "$R please run the script with root user access $N" | tee -a $LOG_FILE
    exit 1
fi

echo -e "Script started executing at$G $(date) $N"     | tee -a $LOG_FILE

VALIDATE (){
    if [ $? -ne 0 ]
    then
        echo -e "$2 is  $R FAILED.. $N"    | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is $G SUCCESS.. $N"    | tee -a $LOG_FILE
    fi
}

dnf install nginx -y       &>>$LOG_FILE
VALIDATE $? "Installing nginx"
 
systemctl enable nginx       &>>$LOG_FILE
VALIDATE $? "Enabling Nginx"

systemctl start nginx        &>>$LOG_FILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/*        &>>$LOG_FILE
VALIDATE $? "removing default website"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip   &>>$LOG_FILE
VALIDATE $? "Downloading frontend code"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip  &>>$LOG_FILE
VALIDATE $? "extracting frontend code"

cp /home/ec2-user/shell-pract/expense.conf /etc/nginx/default.d/expense.conf

systemctl restart nginx    &>>$LOG_FILE
VALIDATE $? "Re-starting nginx"

