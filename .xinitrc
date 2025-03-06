#!/bin/sh


#$HOME/Shiv/Linux/suckless/some_scripts/bin/setwall &
picom &
xwallpaper --zoom $(cat ~/.cache/wal/wal) &
xrdb $HOME/.cache/wal/colors.Xresources
slstatus &

#while true; do
#	dwm >/dev/null 2>&1
#done
exec dwm
#dbus-run-session /usr/bin/local/dwm
