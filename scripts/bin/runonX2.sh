#!/bin/bash
export DISPLAY=:1
test -e /tmp/.X1-lock || nohup X :1 > /tmp/x2.log &
$@
