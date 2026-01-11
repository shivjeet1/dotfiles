#!/bin/bash

# --- 1. Argument Validation ---

# Check if a wallpaper path was provided
if [ -z "$1" ]; then
    echo "🚨 ERROR: Please provide the path to the wallpaper as the first argument."
    echo "Usage: $0 /path/to/your/wallpaper.jpg"
    exit 1
fi

WALLPAPER_PATH="$1"

if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "🚨 ERROR: Wallpaper file not found at '$WALLPAPER_PATH'."
    exit 1
fi

echo "🎨 Starting Hyprland Theme Setup with: $WALLPAPER_PATH"

# --- 2. Generate Pywal Colors and Set Wallpaper ---

# -R: Recolor applications (optional, but good practice)
# -o: Only generate colors (prevents setting the wallpaper via pywal's old method)
# This will update ~/.cache/wal/colors.json and set the wallpaper for Hyprpaper
echo "Step 2/6: Generating pywal colors and setting background..."
wal -i "$WALLPAPER_PATH"

if [ $? -ne 0 ]; then
    echo "🚨 ERROR: Pywal command failed. Ensure 'pywal' is installed."
    exit 1
fi

# --- 3. Run Custom Configuration Generator Script ---

# IMPORTANT: Replace this path with the actual location of your gen-conf.py
GEN_CONF_SCRIPT="$HOME/dotfiles/scripts/gen-conf.py" 

echo "Step 3/6: Running custom configuration generator..."
if [ -f "$GEN_CONF_SCRIPT" ]; then
    python "$GEN_CONF_SCRIPT"

    if [ $? -ne 0 ]; then
        echo "⚠️ WARNING: Custom script '$GEN_CONF_SCRIPT' failed to execute."
    else
        echo "Successfully generated colors-hyprland.conf."
    fi
else
    echo "⚠️ WARNING: Custom script '$GEN_CONF_SCRIPT' not found. Skipping generation."
fi

# --- 4. Reload Terminal Colors ---

echo "Step 4/6: Reloading terminal colors (for existing terminals)..."
# This command sources the pywal theme file into the current shell session.
# If you use a terminal other than Kitty/Alacritty/etc., you may need to
# replace this with a specific command (e.g., 'pkill -SIGUSR1 alacritty').
source "$HOME/.cache/wal/colors.sh"

# --- 5. Update hyprpaper.conf and Reload Hyprpaper ---

# Assuming your Hyprpaper config is at the standard location:
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf" 

echo "Step 5/6: Updating $HYPRPAPER_CONF and reloading hyprpaper..."

if [ -f "$HYPRPAPER_CONF" ]; then
    # 5a. Update the hyprpaper.conf file
    # This sed command finds the 'preload =' line and replaces the path with the new one.
    # It assumes the file is already structured with a 'preload' line.
    sed -i "s|^preload =.*$|preload = $WALLPAPER_PATH|" "$HYPRPAPER_CONF"
    
    # 5b. Check if the 'wallpaper' line exists and update it, or add it if missing.
    if grep -q "^wallpaper = " "$HYPRPAPER_CONF"; then
        sed -i "s|^wallpaper =.*$|wallpaper = eDP-1,$WALLPAPER_PATH|" "$HYPRPAPER_CONF"
    else
        # Append to the end if not found (assuming your monitor name is 'eDP-1')
        echo "wallpaper = eDP-1,$WALLPAPER_PATH" >> "$HYPRPAPER_CONF"
    fi
    
    # IMPORTANT: You must change 'eDP-1' to your actual monitor name (e.g., 'HDMI-A-1').
    echo "⚠️ Make sure 'eDP-1' in hyprpaper.conf matches your actual monitor name!"

    # 5c. Reload hyprpaper
    pkill -SIGUSR1 hyprpaper
    echo "Hyprpaper reloaded."
else
    echo "⚠️ WARNING: Hyprpaper config not found at $HYPRPAPER_CONF. Skipping update/reload."
fi

# --- 6. Reload Waybar ---

echo "Step 6/6: Reloading Waybar..."
# Sends a SIGUSR2 signal to the Waybar process to force it to reload its configuration.
pkill -SIGUSR2 waybar
echo "Waybar reloaded."

echo "✅ All steps completed! New theme is now active."
