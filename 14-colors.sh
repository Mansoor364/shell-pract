#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

ROOT_CHECK(){
    USERID=$(id -u)
    if [ $USERID -ne 0 ]
    then
        echo -e "$R please run the script with root user privileges $N"
        exit 1
    fi
}
ROOT_CHECK

USAGE(){
    echo -e "$R USAGE :: sudo sh 14-colors.sh package1 package2...$N"
    exit 1
}
if [ $# -eq 0 ]
then
    USAGE
fi

echo -e "$Y Script started executing at :$(date) $N"

VALIDATE (){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R FAILED.. $N"
        exit 1
    else
        echo -e "$2 is $G SUCCESS.. $N"
    fi
}

for package in $@
do
    dnf list installed $package
    if [ $? -ne 0 ]
    then
        echo -e "$package is not installed.. $Y going to install it..$N"
        dnf install $package
        VALIDATE $? "Installing $package"
    else
        echo -e "$package is already $Y installed nothing to do $N"
    fi
done
