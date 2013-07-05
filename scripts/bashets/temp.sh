#!/bin/bash
TEMP=$(cat /sys/devices/platform/coretemp.0/temp1_input)
TEMP=$(($TEMP/1000))

if [ $TEMP -lt 70 ]; then
    COLOR="#00FF00"
elif [ $TEMP -lt 85 ]; then
    COLOR="#ff9c00"
else
    COLOR="#FF0000"
fi
echo -n "<span color=\"$COLOR\">${TEMP}°C</span>"
