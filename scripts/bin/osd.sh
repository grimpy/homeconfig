#!/bin/sh
cmd=$2
      if [ $1 == '+' ] ;
      then
              amixer -c 0 set $cmd 5%+
      fi
      if [ $1 == '0' ];
      then
	      amixer -c 0 set "$cmd" toggle
	      echo `amixer -c 0 get "$cmd" | grep "Front Left:" | awk -F[ '{print $4}' | awk -F] '{print $1}'` | xargs setosd 
      fi
      if [ $1 == '-' ];
      then
              amixer -c 0 set $cmd 5%-
      fi
[ $1 == '0' ] || exec echo `amixer -c 0 get $cmd | grep Left: | awk -F[ '{print $2}' | awk -F] '{print $1}'` | xargs setosd
