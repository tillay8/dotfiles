#!/bin/bash
THEME=$(head -n 1 /home/$USER/.config/macos/icons/THEME)
STATUS=$(mullvad status)
if [[ $STATUS == *"Connected"* ]]; then
    echo "/home/$USER/.config/macos/icons/$THEME/vpn/vpn-connected.png"
elif [[ $STATUS == *"Disconnected"* ]]; then
    echo "/home/$USER/.config/macos/icons/$THEME/vpn/vpn-disconnected.png"
elif [[ $STATUS == *"Blocked"* ]]; then
    echo "/home/$USER/.config/macos/icons/$THEME/vpn/vpn-blocked.png"
fi

