#!/bin/bash

#how to get all arguments passed to script
echo "all arguments passed to script are : $@"

#how do you print no of arguments passed to script
echo "number of values passed to script are : $#"

#what is name of current script
echo "name of current script : $0"

#what is current working directory of user logged in
echo "current working directory of user: $PWD"

#what is home directory of user logged in
echo "home directory of logged user : $HOME"

#process instance id of last executed file/script
echo "process instance id of last executed script: $$"

sleep 100 &
#process instance id of last executed command
echo "process instance id of last executed baground command: $!"
