#!/bin/sh

# Detect host type
if command -v detect-hosttype >/dev/null 2>&1; then
  HOSTTYPE=$(detect-hosttype)
  export HOSTTYPE
  [ -f "$HOME/.config/environment.d/10-${HOSTTYPE}.conf" ] &&
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

# Configure monitors
wlr-randr --output DP-2 --mode 2560x1440@143.994995 --left-of DP-1

# Notification daemon
pgrep -x mako >/dev/null 2>&1 || mako &

# Wallpaper setter
setbg ~/.local/share/wallpapers

# Clipboard manager
pgrep -f 'wl-paste --watch cliphist store' >/dev/null 2>&1 || wl-paste --watch cliphist store &

pgrep -x 'walker' >/dev/null 2>&1 || walker --gapplication-service &
pgrep -x 'swayosd-server' >/dev/null 2>&1 || swayosd-server &
pgrep -x 'swayidle' >/dev/null 2>&1 || swayidle \
  timeout 300 'brightnessctl set 30%' \
  timeout 600 'waylock' \
  timeout 900 'systemctl suspend' \
  resume 'brightnessctl set 100%' \
  before-sleep 'waylock'

# Foot terminal server (for footclient spawning)
pgrep -f 'foot --server' >/dev/null 2>&1 || foot --server &
