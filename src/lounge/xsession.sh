#!/bin/bash
(
set -x
export DISPLAY=:0
export HOME=/lounge
export PATH="/lounge/bin/:$PATH"
sudo -u lounge xhost +
sudo -u lounge /usr/bin/python /lounge/bin/proxy.py &>/tmp/proxy &
#resolution="$(sudo -u lounge /lounge/bin/janosh -r get /display/resolution)"
#sudo -u lounge /lounge/bin/janosh -t set /display/resolution $resolution

# apply real resolution
#resolution="`xrandr -q | fgrep "*" | tr -s " " | cut -d" " -f2`"
#sudo -u lounge /lounge/bin/janosh -t set /display/resolution $resolution

xset -dpms
xset s off

xbindkeys & 
# somehow the first message doesnt make it
janosh publish something
awesome 
) &> /tmp/xsession

