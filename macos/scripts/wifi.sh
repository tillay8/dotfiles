#!/bin/bash
THEME=$(head -n 1 /home/$USER/.config/macos/icons/THEME)

ETHERNET_STATUS=$(nmcli -t -f DEVICE,STATE dev | grep -E 'ethernet.*connected')

if [ -n "$ETHERNET_STATUS" ]; then
    echo "/home/$USER/.config/macos/icons/$THEME/wifi/ethernet.png"
    exit 0
fi

WIFI_STATUS=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep '^yes')

if [ -z "$WIFI_STATUS" ]; then
    echo "/home/$USER/.config/macos/icons/$THEME/wifi/wifi-off.png"
    exit 0
else
    SSID=$(echo "$WIFI_STATUS" | cut -d ':' -f 2)
    SIGNAL=$(echo "$WIFI_STATUS" | cut -d ':' -f 3)

    if [ "$SSID" == "xfinitywifi" ]; then
        echo "/home/$USER/.config/macos/icons/$THEME/wifi/xfinity.png"
    else
        if [ "$SIGNAL" -le 25 ]; then
            echo "/home/$USER/.config/macos/icons/$THEME/wifi/wifi-0.png"
        elif [ "$SIGNAL" -le 50 ]; then
            echo "/home/$USER/.config/macos/icons/$THEME/wifi/wifi-1.png"
        elif [ "$SIGNAL" -le 75 ]; then
            echo "/home/$USER/.config/macos/icons/$THEME/wifi/wifi-2.png"
        else
            echo "/home/$USER/.config/macos/icons/$THEME/wifi/wifi-3.png"
        fi
    fi
fi

ping -c 1 8.8.8.8 &>/dev/null

if [ $? -ne 0 ]; then
    echo "/home/$USER/.config/macos/icons/$THEME/wifi/broken.png"
    exit 0
fi

