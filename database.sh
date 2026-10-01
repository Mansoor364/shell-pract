#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.sh"

mkdir -p $LOGS_FOLDER

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo -e "$R please run the script with root access $N"
    exit 1
fi

echo -e "Script started executing at $G : $(date) $N"

VALIDATE (){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R FAILED.. $N"
        exit 1
    else
        echo -e "$2 is $G SUCCESS.. $N"
    fi
}

dnf install mysql-server -y      &>>$LOG_FILE
VALIDATE $? "Installing mysql-server"

systemctl enable mysqld          &>>$LOG_FILE
VALIDATE $? "Enabling mysql-server"

systemctl start mysqld           &>>$LOG_FILE
VALIDATE $? "Starting mysql-server"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "Setting root-pass"


