#!/bin/bash
STATUS=$(mullvad status)
if [[ $STATUS == *"Connected"* ]]; then
    echo "/home/$USER/.config/waybar/vpn-connected.png"
elif [[ $STATUS == *"Disconnected"* ]]; then
    echo "/home/$USER/.config/waybar/vpn-disconnected.png"
elif [[ $STATUS == *"Blocked"* ]]; then
    echo "/home/$USER/.config/waybar/vpn-blocked.png"
elif [[ $STATUS == *"Connecting"* ]]; then
    echo "/home/$USER/.config/waybar/vpn-blocked.png"
fi
