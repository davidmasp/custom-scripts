#!/usr/bin/bash

outfile=$(date +%y%m%d)_du.tsv
outfolder=$3
outpath=${outfolder}/${outfile}
directory=$1
topN=$2

du -hc --max-depth=2 ${directory} | sort -rh | head -n ${topN} | tee ${outpath}

