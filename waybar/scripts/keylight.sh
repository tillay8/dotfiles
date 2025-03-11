#!/bin/bash
brightness=$(brightnessctl -d platform::kbd_backlight g)
case "$brightness" in
    0)
        return=" 0"
        ;;
    1)
        return=" 1"
        ;;
    2)
        return=" 2"
        ;;
    *)
        echo " ?"
        exit 1
        ;;
esac

echo "$return"

