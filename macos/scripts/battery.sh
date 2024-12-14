#!/bin/bash
THEME=$(head -n 1 /home/$USER/.config/macos/icons/THEME)

battery_device=$(upower -e | grep 'battery' | head -n 1)

battery_percent=$(upower -i "$battery_device" | grep -E 'percentage' | awk '{print $2}' | sed 's/%//')

charging_status=$(upower -i "$battery_device" | grep -E 'state' | awk '{print $2}')

base_path="/home/$USER/.config/macos/icons/$THEME/battery"

if [[ "$charging_status" == "charging" ]]; then
    echo "$base_path/charging.png"
else
    if [ "$battery_percent" -ge 80 ]; then
        echo "$base_path/5.png"
    elif [ "$battery_percent" -ge 60 ]; then
        echo "$base_path/4.png"
    elif [ "$battery_percent" -ge 40 ]; then
        echo "$base_path/3.png"
    elif [ "$battery_percent" -ge 20 ]; then
        echo "$base_path/2.png"
    elif [ "$battery_percent" -ge 10 ]; then
        echo "$base_path/1.png"
    else
        echo "$base_path/0.png"
    fi
fi

