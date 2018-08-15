#!/usr/bin/env bash

# $1: A directory containing wallpapers
# $2: A directory that should contain the current wallpaper
#
# Selects a new wallpaper from $1 and makes it the current background.


wallpaper_dir=$(readlink -f "$1")
current_wallpaper_location="${2%%/}"

old_background=$(gsettings get org.gnome.desktop.background picture-uri\
    | sed -r "s|'file://(.*)'|\1|")
if [[ -f $old_background ]]; then
    old_background_name=$(basename "$old_background")
fi

new_background=$(find "$wallpaper_dir" -type f\
    | grep -Fv "${old_background_name:-not a file name}"\
    | shuf -n1)
new_background_name=$(basename "$new_background")

cp "$new_background" "$current_wallpaper_location"
new_background_uri="file://${current_wallpaper_location}/${new_background_name}"
gsettings set org.gnome.desktop.background picture-uri "$new_background_uri"
gsettings set org.gnome.desktop.screensaver picture-uri "$new_background_uri"

if [[ -n $old_background_name ]]; then
    rm "${current_wallpaper_location}/${old_background_name}"
fi
