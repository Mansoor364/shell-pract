#!/bin/bash
echo "enter a number:"
read -s num
if [ $num -ge 25 ]                   #-ge,-le,-gt,-lt,-eq,-ne
then
    echo "entered number $num is greater than or equal to 25"
else
    echo "entered number $num is less than 25