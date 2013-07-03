#!/bin/bash
gwif=$(ip r | grep default | awk '{print $5}')
gwip=$(ip a s $gwif | grep 'inet ' | awk '{print $2}' | cut -f 1 -d '/')
echo -n $gwip
