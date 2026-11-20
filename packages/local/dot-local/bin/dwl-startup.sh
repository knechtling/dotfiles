#!/bin/sh

# Detect host type
if command -v detect-hosttype >/dev/null 2>&1; then
  HOSTTYPE=$(detect-hosttype)
  export HOSTTYPE
  if [ -f "$HOME/.config/hosttype/${HOSTTYPE}.conf" ]; then
    set -a
    . "$HOME/.config/hosttype/${HOSTTYPE}.conf"
    set +a
  fi
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

# Bring up the dwl session target; via BindsTo it also starts
# graphical-session.target, so user units with WantedBy=graphical-session.target
# (e.g. solaar.service) autostart with the compositor.
#
# startw restarts dwl without tearing the session down, so the targets may
# still be active from the previous dwl. Stop them first: otherwise "start"
# is a no-op and autostart apps that died with the old dwl stay dead.
if command -v systemctl >/dev/null 2>&1; then
  systemctl --user stop graphical-session.target xdg-desktop-autostart.target
  systemctl --user reset-failed
  systemctl --user start dwl-session.target
fi

# Start gnome-keyring-daemon only if it's not running, and export env vars
# eval "$(gnome-keyring-daemon --start --foreground --components=secrets,ssh,pkcs11)"
# export SSH_AUTH_SOCK

# Configure monitors (only if the expected outputs are actually present;
# otherwise wlr-randr exits non-zero with "invalid output: DP-1").
if command -v wlr-randr >/dev/null 2>&1; then
  _outputs=$(wlr-randr 2>/dev/null)
  case "$_outputs" in
  *"DP-1"*"DP-2"* | *"DP-2"*"DP-1"*)
    wlr-randr --output DP-2 --mode 2560x1440@143.994995 --left-of DP-1
    ;;
  esac
  unset _outputs
fi

# Notification daemon
pgrep -x mako >/dev/null 2>&1 || mako &

# Wallpaper: keep the last one (wallpaper-menu/setbg), else GNOME's, else random
if [ -e "${XDG_DATA_HOME:-$HOME/.local/share}/bg" ]; then
  setbg
elif [ -f "$HOME/.config/background" ]; then
  setbg "$HOME/.config/background"
else
  setbg ~/.local/share/wallpapers
fi

# Monitor profiles per dock/desk (converted from GNOME: gnome2kanshi)
pgrep -x kanshi >/dev/null 2>&1 || kanshi &

# Laptop: panel off with lid closed while docked, low battery warnings
if [ "$HOSTTYPE" = laptop ]; then
  pgrep -f 'lid-watch' >/dev/null 2>&1 || lid-watch &
  pgrep -f 'battery-notify' >/dev/null 2>&1 || battery-notify &
fi

# Automount USB drives like GNOME/Nautilus (tray icon for unmount)
if command -v udiskie >/dev/null 2>&1; then
  pgrep -x udiskie >/dev/null 2>&1 || udiskie --tray --notify &
fi

# Clipboard manager
pgrep -f 'wl-paste --watch cliphist store' >/dev/null 2>&1 || wl-paste --watch cliphist store &

pgrep -x 'swayidle' >/dev/null 2>&1 || swayidle -w -C "$HOME/.config/swayidle/config" &

# Foot terminal server (for footclient spawning)
pgrep -f 'foot --server' >/dev/null 2>&1 || foot --server &

# swayosd-server for visual popups
pgrep -x swayosd-server >/dev/null 2>&1 || swayosd-server &

# Walker service (optional; app-launcher falls back to rofi without it)
if command -v walker >/dev/null 2>&1; then
  pgrep -f 'walker --gapplication-service' >/dev/null 2>&1 || walker --gapplication-service &
fi
