#!/bin/bash
COMMAND=$1
CON=($(xrandr -q | grep " connected" | cut -f 1 -d ' '))

usage() {
    echo Usage $0 [--single --dual --clone]
}

echo ${CON[1]}

if [ ${#CON[*]} -gt 1 ]; then
    xrandr --output ${CON[1]} --auto
fi


single() {
    xrandr --output ${CON[1]} --off
}
dual() {
    xrandr --output ${CON[0]} --left-of ${CON[1]} --auto
}
clone() {
    xrandr --output ${CON[1]} --same-as ${CON[0]}
}
toggle() {
    if [ ${#CON[*]} -gt 1 ]; then
        single
    else
        dual
    fi
    
}

case ${COMMAND} in
    --single) single;;
    --dual) dual;;
    --clone) clone;;
    --toggle) toggle;;
    *) usage
esac

