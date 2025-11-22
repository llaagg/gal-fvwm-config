#!/bin/bash
#
# Rotate wallpapers every 30 seconds from ~/.fvwm/background/
#

WALLPAPER_DIR="$HOME/.fvwm/background"
INTERVAL=300

# Create directory if it doesn't exist
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Creating wallpaper directory: $WALLPAPER_DIR"
    mkdir -p "$WALLPAPER_DIR"
    echo "Please add wallpaper images to $WALLPAPER_DIR"
    exit 1
fi

# Check if there are any images
shopt -s nullglob
IMAGES=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,JPG,JPEG,PNG})
shopt -u nullglob

if [ ${#IMAGES[@]} -eq 0 ]; then
    echo "No images found in $WALLPAPER_DIR"
    echo "Please add .jpg or .png images to this directory"
    exit 1
fi

echo "Found ${#IMAGES[@]} wallpapers in $WALLPAPER_DIR"
echo "Rotating every $INTERVAL seconds..."
echo "Press Ctrl+C to stop"

# Infinite loop to change wallpapers
while true; do
    for img in "${IMAGES[@]}"; do
        echo "Setting: $(basename "$img")"
        feh --bg-fill "$img" 2>/dev/null || fvwm3-root "$img" 2>/dev/null
        sleep "$INTERVAL"
    done
done
