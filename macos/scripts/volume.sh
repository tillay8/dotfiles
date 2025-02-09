#!/bin/bash
DEFAULT_SINK=$(pactl get-default-sink)
VOLUME=$(pactl get-sink-volume "$DEFAULT_SINK" | grep -oP '\d+%' | head -1 | tr -d '%')

MUTED=$(pactl get-sink-mute "$DEFAULT_SINK" | awk '{print $2}')

if [ "$MUTED" == "yes" ]; then
    echo "/home/$USER/.config/macos/icons/audio/mute.png"
    exit 0
fi

if [ "$VOLUME" -lt 20 ]; then
    echo "/home/$USER/.config/macos/icons/audio/vol-0.png"
elif [ "$VOLUME" -lt 50 ]; then
    echo "/home/$USER/.config/macos/icons/audio/vol-1.png"
elif [ "$VOLUME" -lt 80 ]; then
    echo "/home/$USER/.config/macos/icons/audio/vol-2.png"
else
    echo "/home/$USER/.config/macos/icons/audio/vol-3.png"
fi

