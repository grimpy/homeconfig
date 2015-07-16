#!/bin/bash
COMMAND=$1
CON=($(xrandr -q | grep " connected" | cut -f 1 -d ' '))
ENABLED=($(xrandr -q | grep "connected [0-9]" | cut -f 1 -d ' '))
SCALE="1.5"
EXT=${CON[1]}
INT=${CON[0]}

usage() {
    echo Usage $0 [--single --dual --clone]
}


function getres() {
    xrandr -q | grep "$1" -A1 | tail -1 | awk '{print $1}' | cut -d x -f $2
}

if [ ${#CON[*]} -gt 1 ]; then
    xrandr --output ${CON[1]} --auto
fi

single() {
    xrandr --output ${CON[1]} --off
}
dual() {
    int_w=$(getres $INT 1)

    if [ $int_w -gt 1920 ]; then
        ext_w=$(getres $EXT 1)
        ext_w=$(getres $EXT 1)
        ext_h=$(getres $EXT 2)


        pan_w=$(echo "${ext_w} ${SCALE}" | awk '{printf "%.0f\n",$1*$2}')
        pan_h=$(echo "${ext_h} ${SCALE}" | awk '{printf "%.0f\n",$1*$2}')

        xrandr --output "${INT}" --auto --output "${EXT}" --auto --panning "${pan_w}x${pan_h}+${int_w}+0" --scale "${SCALE}x${SCALE}" --right-of "${INT}"

        ext_h=$(getres $EXT 2)
        int_w=$(getres $INT 1)

        pan_w=$(echo "${ext_w} ${SCALE}" | awk '{printf "%.0f\n",$1*$2}')
        pan_h=$(echo "${ext_h} ${SCALE}" | awk '{printf "%.0f\n",$1*$2}')

        xrandr --output "${INT}" --auto --output "${EXT}" --auto --panning "${pan_w}x${pan_h}+${int_w}+0" --scale "${SCALE}x${SCALE}" --right-of "${INT}"
    else
        xrandr --output ${CON[0]} --left-of ${CON[1]} --auto
    fi
}
clone() {
    xrandr --output ${CON[1]} --same-as ${CON[0]}
}
auto() {
    if [ ${#ENABLED[*]} -gt 1 ]; then
        single
    else
        dual
    fi
    
}

case ${COMMAND} in
    --single) single;;
    --dual) dual;;
    --clone) clone;;
    --auto) auto;;
    *) usage
esac

