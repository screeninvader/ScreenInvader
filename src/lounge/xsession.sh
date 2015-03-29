#!/bin/bash
(
set -x
export DISPLAY=:0
export HOME=/root
export PATH="/lounge/bin/:$PATH"
sudo -u lounge xhost +
sudo -u lounge /lounge/bin/showip &>/dev/null &
sudo -u lounge /usr/bin/python /lounge/bin/proxy.py &>/tmp/proxy &
sudo -u lounge dunst -fn "-misc-topaz a500a1000a2000-medium-r-normal--0-240-0-0-c-0-iso8859-1" -to 1 &
#resolution="$(sudo -u lounge /lounge/bin/janosh -r get /display/resolution)"
#sudo -u lounge /lounge/bin/janosh -t set /display/resolution $resolution

# apply real resolution
#resolution="`xrandr -q | fgrep "*" | tr -s " " | cut -d" " -f2`"
#sudo -u lounge /lounge/bin/janosh -t set /display/resolution $resolution

#sudo -u lounge cheesy -d -t &> /var/log/cheesy.log &
xset -dpms
xset s off

xbindkeys & 
awesome 
) &> /tmp/xsession

