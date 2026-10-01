#!/bin/bash

USERID=$(id -u)
ROOT_CHECK(){
    if [ $? -ne 0 ]
    then
        echo "please run the script with root user privileges"
        exit 1
    fi
}

ROOT_CHECK

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 is FAILED.."
        exit 1
    else
        echo "$2 is SUCCESS."
    fi
}

dnf list installed git 
if [ $? -ne 0 ]
then
    echo "git is not installed, going to install it"
    dnf install git -y
    VALIDATE $? "Installing git"
else
    echo "git is already installed nothing to do"
fi

dnf list installed mysql
if [ $? -ne 0 ]
then
    echo "mysql is not installed, going to install it"
    dnf install mysql -y
    VALIDATE $? "Installing MYSQL"
else
    echo "mysql is already installed nothing to do "
fi



