#!/usr/bin/env bash

# Calls randomize-background.sh from cron scripts.

set -x

load_environ() {
    eval $2="$(grep -z "$2" "/proc/$1/environ" | cut -d= -f2-)"
    export "$2"
}

USER=$(whoami)
PID=$(pgrep -u "$USER" gnome-session | head -1)
load_environ "$PID" DBUS_SESSION_BUS_ADDRESS

randomize-background.sh "$@"
