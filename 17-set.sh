#!/bin/bash

set -e     #setting automatic exit when command fails to exit,, 

#set -ex --> setting automatic exit and debug(display more info on terminal)
failure(){
    echo "script failed at $1:$2"
}

trap 'failure "${LINENO}" "$BASH_COMMAND"' ERR
echo "Hello world - Sucess"
echoooooo "Hello world --failure"
echo "Hello world -after failure"