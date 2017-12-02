#!/bin/bash
if [ -d "$1" ]; then
    timestamp=`date +%y%m%d_%H%M%S`
    maim -s -k -u ${1}/${timestamp}.png
    echo -n "${1}/${timestamp}.png" | xclip -selection clipboard
else 
    maim -s -k -u |  xclip -selection clipboard -t image/png
fi
