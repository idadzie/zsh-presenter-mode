#!/bin/bash

# https://superuser.com/questions/157563/programmatic-access-to-current-xterm-background-color

success=false
exec < /dev/tty
oldstty=$(stty -g)
stty raw -echo min 0
echo -en "\033]11;?\033\\" >/dev/tty
result=
if IFS=';' read -r -d '\' color ; then
    result=$(echo $color | sed 's/^.*\;//;s/[^rgb:0-9a-f/]//g')
    success=true
fi
stty $oldstty
echo $result
$success
