#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SOURCE_DIR="/home/ec2-user/log"            #at what directory log files are present

if [ -d $SOURCE_DIR ]
then
    echo -e "$SOURCE_DIR $G exists..$N"
else
    echo -e "$SOURCE_DIR $R doesn't exist $N please check it"
    exit 1 
fi

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +14)
echo -e "$Y log files older than 14 days are $N : $FILES"

while IFS= read -r file
do
    echo "deleting files : $file"
    rm -rf $file
done <<<$FILES
