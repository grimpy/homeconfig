#!/bin/bash
FULLCHARGE=$(cat /sys/class/power_supply/BAT?/charge_full)
CURRENTCHARGE=$(cat /sys/class/power_supply/BAT?/charge_now)
CPU=$(($CURRENTCHARGE*100/$FULLCHARGE))
STATE=$(cat /sys/class/power_supply/BAT?/status)
echo -n $CPU
case $STATE in
    Charging) 
        echo -n +
        ;;
    Discharging)
        echo -n -
        ;;
    Full)
        echo -n ↯
        ;;
esac
