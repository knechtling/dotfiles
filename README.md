# Deploy with gnu stow
clone the repository

`cd dotfiles`

`stow -d /home/anton/dotfiles/packages -t /home/anton --dotfiles --no-folding --[stow|restow|delete] config local shell`

## Lock before suspending on lid close

1. Ensure `systemd-logind` suspends the machine when the lid is closed. Create `/etc/systemd/logind.conf.d/10-lid.conf` (as root) with for example:

   ```
   [Login]
   HandleLidSwitch=suspend
   HandleLidSwitchDocked=suspend
   ```

   Reload logind afterwards with `sudo systemctl restart systemd-logind`.
2. Enable the user service that locks with waylock before every suspend/hibernate:

   ```
   systemctl --user enable --now waylock-before-sleep.service
   ```

3. Confirm it ran with `journalctl --user -u waylock-before-sleep.service`. Closing the lid now triggers `waylock -z` before the system enters sleep, so the session is locked as soon as it wakes up.
