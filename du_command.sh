#!/usr/bin/env bash

# we need to ask for the target foder and the du report folder

# t will be the target
# o will be the output

usage() { echo "Usage: $0 [-t path/to/score] [-o path/to/report]" 1>&2; exit 1; }

while getopts "t:o:" o; do
    case "${o}" in
        t)
            TARGET=${OPTARG}
            ;;
        o)
            FOLDER=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${TARGET}" ] || [ -z "${FOLDER}" ]; then
    usage
fi

# params
#FOLDER="/home/dmas/.du_reports"
#TARGET=$HOME

# generate files
mkdir -p $FOLDER
TODAY=$(date "+%Y%m%d")
OUTPUT=$FOLDER/$TODAY"_disk_usage_table.tsv"

# header
echo "size(mb)\tfile" > $OUTPUT

# run command
du -am $TARGET | sort -nr -k1 >> $OUTPUT
