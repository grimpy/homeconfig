#!/bin/bash
TEMP=$(cat /sys/devices/platform/coretemp.0/temp1_input)
TEMP=$(($TEMP/1000))
echo -n $TEMP
