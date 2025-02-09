#!/bin/bash

battery_device=$(upower -e | grep 'battery' | head -n 1)
battery_percent=$(upower -i "$battery_device" | grep -E 'percentage' | awk '{print $2}' | sed 's/%//')
charging_status=$(upower -i "$battery_device" | grep -E 'state' | awk '{print $2}')

base_path="/home/$USER/.config/macos/icons/battery"

if [ "$battery_percent" -ge 80 ]; then
    icon="5"
elif [ "$battery_percent" -ge 60 ]; then
    icon="4"
elif [ "$battery_percent" -ge 40 ]; then
    icon="3"
elif [ "$battery_percent" -ge 20 ]; then
    icon="2"
elif [ "$battery_percent" -ge 10 ]; then
    icon="1"
else
    icon="0"
fi

if [[ "$charging_status" == "discharging" ]]; then
    echo "$base_path/$icon.png"
else
    echo "$base_path/$icon-charging.png"
fi