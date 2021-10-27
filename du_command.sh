#!/usr/bin/env bash

# we need to ask for the target foder and the du report folder

# t will be the target
# o will be the output
# d will be max depth
# n will be total reported entries

usage() { echo "Usage: $0 -t path/to/score -o path/to/report [-d 2] [-n 20]" 1>&2; exit 1; }

MAXDEPTH=2
TOPN=20

while getopts "t:o:d:n:" o; do
    case "${o}" in
        t)
            TARGET=${OPTARG}
            ;;
        o)
            FOLDER=${OPTARG}
            ;;
        d)
            MAXDEPTH=${OPTARG}
            ;;
        n)
            TOPN=${OPTARG}
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

# run command
du -hc --max-depth=${MAXDEPTH} ${TARGET} | sort -rh | head -n ${TOPN} | tee ${OUTPUT}
