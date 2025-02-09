#!/bin/bash
STATUS=$(mullvad status)
if [[ $STATUS == *"Connected"* ]]; then
    echo "/home/$USER/.config/macos/icons/vpn/vpn-connected.png"
elif [[ $STATUS == *"Disconnected"* ]]; then
    echo "/home/$USER/.config/macos/icons/vpn/vpn-disconnected.png"
elif [[ $STATUS == *"Blocked"* ]]; then
    echo "/home/$USER/.config/macos/icons/vpn/vpn-blocked.png"
fi

