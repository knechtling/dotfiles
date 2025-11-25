#!/bin/sh

# Detect host type
if command -v detect-hosttype >/dev/null 2>&1; then
    HOSTTYPE=$(detect-hosttype)
    export HOSTTYPE
    [ -f "$HOME/.config/environment.d/10-${HOSTTYPE}.conf" ] && \
        . "$HOME/.config/environment.d/10-${HOSTTYPE}.conf"
fi

# Export Wayland and D-Bus environment to systemd user services
if command -v systemctl >/dev/null 2>&1; then
  systemctl --user import-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY \
    DBUS_SESSION_BUS_ADDRESS XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
fi
if command -v dbus-update-activation-environment >/dev/null 2>&1; then
  dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY \
    DBUS_SESSION_BUS_ADDRESS XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
fi

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
