#!/usr/bin/env bash

u_flag='dmas'

print_usage() {
  printf "Usage: ./getPercentatgeJobs.sh -u user"
}

while getopts 'u:' flag; do
  case "${flag}" in
    u) u_flag="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done

USER=$u_flag

RUNNING=$(squeue -u $USER -t RUNNING | wc -l)
TOTALJOBS=$( squeue -u $USER  | wc -l)
ALLJOBS=$(squeue | wc -l)
RALLJOBS=$(squeue -t RUNNING | wc -l)
PERCENTATGERUNNING=$(( 100 * ($RUNNING- 1) / ($TOTALJOBS- 1) ))

JOBSHARE=$(( 100 * ($TOTALJOBS- 1) / ($ALLJOBS - 1) ))
RJOBSHARE=$((100 * ($RUNNING- 1) / ($RALLJOBS - 1) ))

# print
echo "User: $USER"
echo "Total number of jobs: $TOTALJOBS"
echo "Runing jobs: $RUNNING"
echo "Percentatge of jobs running: $PERCENTATGERUNNING %"
echo "Jobs share: $JOBSHARE %"
echo "Running jobs share: $RJOBSHARE %"

