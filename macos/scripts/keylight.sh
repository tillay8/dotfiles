#!/bin/bash
brightness=$(brightnessctl -d platform::kbd_backlight g)
case "$brightness" in
    0)
        filepath="/home/$USER/.config/macos/icons/keylight/key0.png"
        ;;
    1)
        filepath="/home/$USER/.config/macos/icons/keylight/key1.png"
        ;;
    2)
        filepath="/home/$USER/.config/macos/icons/keylight/key2.png"
        ;;
    *)
        echo "Unknown brightness level: $brightness"
        exit 1
        ;;
esac

# Return the filepath
echo "$filepath"

