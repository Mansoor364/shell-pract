#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SOUR_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}                  #arugument 3 is optional, if empty then 14 will be considered
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)

USAGE(){
    echo -e "$R USAGE:: $N sh 19-backup.sh source-direct destination-direc days(optional)"
    exit 1 
}

if [ $# -lt 2 ]
then
    USAGE
fi

if [ ! -d $SOUR_DIR ]
then
    echo -e "$SOURC_DIR doesn't exist $R please provide source directory of log files$N"
    exit 1
fi

if [ ! -d $DEST_DIR ]
then
    echo -e "$DEST_DIR doesn't exist $R please provide destination directory $Y"
    exit 1
fi

FILES=$(find $SOUR_DIR -name "*.log" -mtime $DAYS)
echo "log files are : $FILES"

if [ ! -Z $FILES ]
then
    echo -e "LOG files older than $G $DAYS are exist $N"
    ZIP_FILE="$DEST_DIR/app-log-$TIME_STAMP.zip"
    find $SOUR_DIR -name "*.log" -mtime $DAYS | zip "$ZIP_FILE" -@
    #check if all log files are zipped or not
    if [ -f $ZIP_FILE ]
    then
        echo -e "log files older than $DAYS are $G zipped successfully $N"
        while IFS=read -r file
        do
            echo -e "$Y deleting file:$N $file"
            rm -rf $file
        done <<<$FILES
    else
        echo -e "log files older than $DAYS zipping failed"
    fi
else
    echo "LOG files older than $DAYS not exist"
fi

