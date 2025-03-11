#!/bin/bash
status=$(playerctl status 2>/dev/null)
if [ "$status" == "Paused" ]; then
  echo "/usr/share/icons/BeautyLine/actions/scalable/media-playback-start.svg"
elif [ "$status" == "Playing" ]; then
  echo "/usr/share/icons/BeautyLine/actions/scalable/media-playback-pause.svg"
elif [ -z "$status" ]; then
  echo ""
fi

