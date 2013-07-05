#!/bin/bash
FULLCHARGE=$(cat /sys/class/power_supply/BAT?/charge_full)
CURRENTCHARGE=$(cat /sys/class/power_supply/BAT?/charge_now)
CPU=$(($CURRENTCHARGE*100/$FULLCHARGE))
STATE=$(cat /sys/class/power_supply/BAT?/status)
COLOR="#0080ff"
case $STATE in
    Charging) 
        SIGN="+"
        ;;
    Discharging)
        SIGN="-"
        if [ $CPU -gt 40 ]; then
            COLOR="#00FF00"
        elif [ $CPU -gt 15 ]; then
            COLOR="#ff9c00"
        else
            COLOR="#FF0000"
        fi
        ;;
    Full)
        SIGN="↯"
        ;;
esac
echo -n "<span color=\"$COLOR\">${CPU}$SIGN</span>"
