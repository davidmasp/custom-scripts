#!/usr/bin/env bash

## usage
# archive.sh folder

## info 
# it generates a tar compresed file (gz) with the last date of a modified 
# file from that folder. This is very helpful to archive folders. 

echo $1

# script to archive a folder
FOLDER=$(realpath -s $1) # this should also remove last slash
lastDate=$(date -r $FOLDER "+%Y%m%d")
DIR=$(basename $FOLDER)

echo $DIR
echo $lastDate

tar -zcf $lastDate-$DIR.tar.gz $DIR


