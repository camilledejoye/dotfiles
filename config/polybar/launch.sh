#!/bin/bash

# Force polybar to restart
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1;  done

wifidevice="$(ls /sys/class/net | grep '^wl' | head -1)"

for monitor in $(polybar --list-monitors | cut -d: -f1); do
    WIRELESS="$wifidevice" MONITOR="$monitor" polybar --reload mainbar &
done

echo 'Polybar started...'
