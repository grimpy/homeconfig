#!/bin/bash
if [ -d $1 ]; then
    timestamp=`date +%y%m%d_%H%M%S`
    import ${1}/${timestamp}.png
fi
