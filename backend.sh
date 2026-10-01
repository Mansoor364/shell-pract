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

dnf module disable nodejs:18 -y               &>>$LOG_FILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y                &>>$LOG_FILE
VALIDATE $? "Enabling Nodejs:20"

dnf install nodejs -y                         &>>$LOG_FILE
VALIDATE $? "Installing nodejs"

id expense                                   &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo -e "expense user is not created,, $G creating expense user $N" | tee -a $LOG_FILE
    useradd expense                           &>>$LOG_FILE
    VALIDATE $? "Creating expense user"
else
    echo -e "$Y Expense user is already created..$N SKIP It"   | tee -a $LOG_FILE
fi

mkdir -p /app    &>>$LOG_FILE
curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>$LOG_FILE
VALIDATE $? "Downloading backend app code"

cd /app
rm -rf /app/*
curl -o /tmp/backend.zip           &>>$LOG_FILE
VALIDATE $? "Extracting backend code"

npm install          &>>$LOG_FILE
VALIDATE $? "buiild tool installation"

cp /home/ec2-user/shell-pract/backend.service /etc/systemd/system/backend.service

dnf install mysql -y       &>>$LOG_FILE
VALIDATE $? "Installing mysql client"

mysql -h mysql.muntaj.fun -uroot -pExpenseApp@1 < /app/schema/backend.sql     &>>$LOG_FILE
VALIDATE $? "Schema loading"

systemctl daemon-reload     &>>$LOG_FILE
VALIDATE $? "daemon-reload"

systemctl enable backend     &>>$LOG_FILE
VALIDATE $? "Enabling backend"

systemctl restart backend     &>>$LOG_FILE
VALIDATE $? "Re-starting backend"







