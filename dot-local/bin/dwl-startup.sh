#!/bin/sh

# Export Wayland and D-Bus environment to systemd user services
# dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY DBUS_SESSION_BUS_ADDRESS

# Start gnome-keyring-daemon only if it's not running, and export env vars
# eval "$(gnome-keyring-daemon --start --foreground --components=secrets,ssh,pkcs11)"
# export SSH_AUTH_SOCK

# Notification daemon
pgrep -x mako >/dev/null 2>&1 || mako &

# Wallpaper setter
setbg ~/.local/share/wallpapers

# Clipboard manager
pgrep -f 'wl-paste --watch cliphist store' >/dev/null 2>&1 || wl-paste --watch cliphist store &

# Foot terminal server (for footclient spawning)
pgrep -f 'foot --server' >/dev/null 2>&1 || foot --server &
