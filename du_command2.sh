#!/usr/bin/bash

outfile=$3
directory=$1
topN=$2

du -hc --max-depth=2 ${directory} | sort -rh | head -n ${topN} | tee ${outfile}


