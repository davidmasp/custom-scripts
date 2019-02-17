#!/usr/bin/bash

## usage
# archive.sh folder

## info 
# it generates a tar compresed file (gz) with the last date of a modified 
# file from that folder. This is very helpful to archive folders. 

# script to archive a folder
FOLDER=$(realpath -s $1) # this should also remove last slash

lastDate=$(find $FOLDER -type f -not -path '*/\.*' -printf "%TY%Tm%Td\n" | sort -nr | head -n 1)

DIR=$(basename $FOLDER)

tar -zcvf $lastDate-$DIR.tar.gz $DIR

