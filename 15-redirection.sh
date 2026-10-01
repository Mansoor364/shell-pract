R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"

CHECK_ROOT(){
    USERID=$(id -u)
    if [ $USERID -ne 0 ]
    then
        echo -e "$R please run the script with root user privileges$N" | tee -a $LOG_FILE
        exit 1
    fi
}
CHECK_ROOT

USAGE(){
    echo -e "$R USAGE::$N $Y sudo sh 15-redirection.sh package1 package2..$N"  | tee -a $LOG_FILE
    exit 1
}

if [ $# -eq 0 ]
then
    USAGE
fi

mkdir -p $LOGS_FOLDER  &>>$LOG_FILE

echo -e "Script started executing at: $G $(date) $N "  | tee -a $LOG_FILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R FAILED..$N"  | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is $G SUCCESS.. $N" | tee -a $LOG_FILE
    fi
}

for package in $@         #all pacakages
do
    dnf list installed $package   &>>$LOG_FILE
    if [ $? -ne 0 ]
    then
        echo -e "$package is not installed, $Y going to install it $N"   | tee -a $LOG_FILE
        dnf install $package -y    &>>$LOG_FILE
        VALIDATE $? "Installing $package"
    else
        echo -e "$package $Y is already installed.. nothing to do $N "    | tee -a $LOG_FILE
    fi
done

