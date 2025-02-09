#!/bin/bash

BLUETOOTH_STATUS=$(bluetoothctl show | grep "Powered: yes")

if [ -z "$BLUETOOTH_STATUS" ]; then
    echo "/home/$USER/.config/macos/icons/bluetooth/off.png"
    exit 0
fi

BLUETOOTH_CONNECTED=$(bluetoothctl info | grep "Connected: yes")

if [ -n "$BLUETOOTH_CONNECTED" ]; then
    echo "/home/$USER/.config/macos/icons/bluetooth/connected.png"
    exit 0
fi

echo "/home/$USER/.config/macos/icons/bluetooth/on.png"

