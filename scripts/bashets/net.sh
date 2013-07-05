#!/bin/bash
IF=$(ip r | grep default | awk '{print $5}')
INT=$1
TYPE=$2

TMPDIR=/dev/shm/bashets/tmp/net/$IF/statistics
STATFILE=/sys/class/net/$IF/statistics/${TYPE}_bytes
if [ ! -e $TMPDIR ]; then
    mkdir -p $TMPDIR
    cat $STATFILE > $TMPDIR/${TYPE}_bytes
    exit 0
fi 
mkdir -p $TMPDIR
prevval=$(cat $TMPDIR/${TYPE}_bytes)
curval=$(cat $STATFILE)
echo $curval > $TMPDIR/${TYPE}_bytes

val=$((($curval-$prevval)/$INT))
UNIT=(B/s KiB MiB GiB)
cnt=1
while [ $val -gt 1048576 ]; do
    val=$(($val/1024))
    cnt=$(($cnt+1))
done
output=$(echo "$val 1024"|awk '{printf "%0.2f", $1 / $2 }') 
if [ $TYPE == "tx" ]; then
    COLOR="#FF0000"
else
    COLOR="#00FF00"
fi
echo -n "<span color=\"$COLOR\">$output ${UNIT[$cnt]}</span>"
