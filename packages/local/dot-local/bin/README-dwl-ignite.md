# dwl ignite system notes

## Snapshot
- OS: Arch Linux, compositor/window manager: `dwl` (Wayland)
- Browser: Firefox 145.0.1 (`pacman -Qi firefox`)
- Audio stack (target): PipeWire 1.4.9 + WirePlumber, with `pipewire-pulse` for Pulse compatibility
- Hardware: HDA Intel PCH, default sink `alsa_output.pci-0000_00_1f.3.analog-stereo`
- Input tweak: `~/.zprofile` exports `MOZ_USE_XINPUT2="1"` for smoother Mozilla input handling

## Audio stack usage (PipeWire + pipewire-pulse)
- Services: enable for the user:  
  `systemctl --user enable --now pipewire pipewire-pulse wireplumber`
- Status checks:  
  `systemctl --user status pipewire pipewire-pulse wireplumber`
- Playback tests:  
  PipeWire-native: `pw-play /usr/share/sounds/freedesktop/stereo/bell.oga`  
  Pulse-compatible: `paplay /usr/share/sounds/freedesktop/stereo/bell.oga`
- Inspect routing:  
  Pulse view: `pactl info`, `pactl list short sinks`, `pactl list short sink-inputs`  
  PipeWire view: `pw-top`, `pw-cli ls Node`, `pw-dump`
- Volume/controls: `pulsemixer` (works via pipewire-pulse), or `wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5`
- Restart everything quickly:  
  ```
  systemctl --user restart pipewire pipewire-pulse wireplumber
  rm -rf ~/.config/pulse  # only if Pulse state gets corrupted; pipewire-pulse will recreate it
  ```

## Desktop bits
- dwl launcher: `dot-local/bin/dwl-startup.sh` (see repo for any custom commands)
- Common helpers in `~/.local/bin` (this repo is stowed there) for recording, screenshots, etc.

## Troubleshooting hints
- If audio is muted/suspended: try `pactl set-sink-port alsa_output.pci-0000_00_1f.3.analog-stereo analog-output-speaker`
- If Firefox stalls on audio: confirm `pactl info` reports `Server Name: PulseAudio (on PipeWire 1.4.x)` after switching; restart Firefox
- For HDMI: check availability via `pactl list cards` and switch profiles with `pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:hdmi-stereo` (if available)
