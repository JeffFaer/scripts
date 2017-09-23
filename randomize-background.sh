#!/usr/bin/env bash

# $1: A directory containing wallpapers
# $2: A directory that should contain the current wallpaper
#
# Selects a new wallpaper from $1 and makes it the current background.

wallpaper_dir=$(readlink -f "$1")
current_wallpaper_location="${2%%/}"

old_background=$(gsettings get org.gnome.desktop.background picture-uri\
    | sed -r "s|'file://(.*)'|\1|")
old_background_name=$(basename "$old_background")

new_background=$(find "$wallpaper_dir" -type f\
    | grep -Fv "${old_background_name}"\
    | shuf -n1)
new_background_name=$(basename "$new_background")

cp "$new_background" "$current_wallpaper_location"
new_background_uri="file://${current_wallpaper_location}/${new_background_name}"
gsettings set org.gnome.desktop.background picture-uri "$new_background_uri"

rm "${current_wallpaper_location}/${old_background_name}"
