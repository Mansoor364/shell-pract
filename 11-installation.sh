#!/bin/bash

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo "please run the script with root user priviliges"
    exit 1
fi

dnf list installed git
if [ $? -ne 0 ]
then
    echo "git is not installed, going to install it.."
    dnf install git -y
    if [ $? -ne 0 ]
    then
        echo "git installation is failed.. check it"
        exit 1
    else
        echo "git installation is success"
    fi
else
    echo "git is already installed nothing to do"
fi

dnf list installed mysql 
if [ $? -ne 0 ]
then
    echo "mysql is not installed.. going to install it"
    dnf install mysql -y
    if [ $? -ne 0 ]
    then
        echo "Installing mysql is failed.. check it"
        exit 1
    else
        echo "mysql installation is success.."
    fi
else
    echo "mysql is already installed.. nothing to do"
fi
