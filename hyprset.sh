#!/bin/bash


if [ -z "$1" ]; then
    echo "ERROR: Please provide the path to the wallpaper as the first argument."
    echo "Usage: $0 /path/to/your/wallpaper.jpg"
    exit 1
fi

WALLPAPER_PATH="$1"

if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "ERROR: Wallpaper file not found at '$WALLPAPER_PATH'."
    exit 1
fi

echo "Starting Hyprland Theme Setup with: $WALLPAPER_PATH"


# This will update ~/.cache/wal/colors.json and set the wallpaper for Hyprpaper
echo "Step 2/6: Generating pywal colors and setting background..."
wal -i "$WALLPAPER_PATH"

if [ $? -ne 0 ]; then
    echo "ERROR: Pywal command failed. Ensure 'pywal' is installed."
    exit 1
fi

# IMPORTANT: Replace this path with the actual location of your gen-conf.py
GEN_CONF_SCRIPT="$HOME/dotfiles/scripts/gen-conf.py" 

echo "Step 3/6: Running custom configuration generator..."
if [ -f "$GEN_CONF_SCRIPT" ]; then
    python "$GEN_CONF_SCRIPT"

    if [ $? -ne 0 ]; then
        echo "WARNING: Custom script '$GEN_CONF_SCRIPT' failed to execute."
    else
        echo "Successfully generated colors-hyprland.conf."
    fi
else
    echo "WARNING: Custom script '$GEN_CONF_SCRIPT' not found. Skipping generation."
fi

echo "Step 4/6: Reloading terminal colors (for existing terminals)..."

source "$HOME/.cache/wal/colors.sh"

HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf" 

echo "Step 5/6: Updating $HYPRPAPER_CONF and reloading hyprpaper..."

if [ -f "$HYPRPAPER_CONF" ]; then
    # It assumes the file is already structured with a 'preload' line.
    sed -i "s|^preload =.*$|preload = $WALLPAPER_PATH|" "$HYPRPAPER_CONF"
    
    if grep -q "^wallpaper = " "$HYPRPAPER_CONF"; then
        sed -i "s|^wallpaper =.*$|wallpaper = eDP-1,$WALLPAPER_PATH|" "$HYPRPAPER_CONF"
    else
        echo "wallpaper = eDP-1,$WALLPAPER_PATH" >> "$HYPRPAPER_CONF"
    fi
    
    echo "Make sure 'eDP-1' in hyprpaper.conf matches your actual monitor name!"

    pkill -SIGUSR1 hyprpaper
    echo "Hyprpaper reloaded."
else
    echo "WARNING: Hyprpaper config not found at $HYPRPAPER_CONF. Skipping update/reload."
fi


echo "Step 6/6: Reloading Waybar..."
pkill -SIGUSR2 waybar
echo "Waybar reloaded."

echo "✅ All steps completed! New theme is now active."
