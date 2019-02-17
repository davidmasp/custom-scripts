#!/usr/bin/env bash

# params
FOLDER="/home/dmas/.du_reports"
TARGET=$HOME

# generate files
mkdir -p $FOLDER
TODAY=$(date "+%Y%m%d")
OUTPUT=$FOLDER/$TODAY"_disk_usage_table.tsv"

# header
echo "size(mb)\tfile" > $OUTPUT

# run command
du -am $TARGET | sort -nr -k1 >> $OUTPUT
