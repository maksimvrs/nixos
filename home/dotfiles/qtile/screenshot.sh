#!/bin/sh
# Screenshot helper for grim + slurp on Wayland.
# Usage: screenshot.sh [region|full]

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

case "${1:-region}" in
  region)
    grim -g "$(slurp)" "$FILE" || exit 0
    ;;
  full)
    grim "$FILE"
    ;;
esac

wl-copy < "$FILE"
dunstify -r 91192 -t 2000 -i "$FILE" "📸 Screenshot" "Saved & copied"
