#!/bin/bash
subname=$2
track=$1
mountpoint=$3
echo "Getting subs"
tccat -i /dev/sr0 -T ${track},1-1000  | tcextract -x ps1 -t vob -a 0x21 >| "${subname}.raw"
subtitle2vobsub -p "${subname}.raw" -i ${mountpoint}/VIDEO_TS/VTS_0${track}_0.IFO -o "${subname}"
