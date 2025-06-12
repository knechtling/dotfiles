#!/bin/sh

dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY
mako &
setbg ~/.local/share/wallpapers
wl-paste --watch cliphist store &
foot --server &
