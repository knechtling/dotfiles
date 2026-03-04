# Deploy with gnu stow
clone the repository

`cd dotfiles`

`stow -d /home/anton/dotfiles/packages -t /home/anton --dotfiles --no-folding --[stow|restow|delete] config local shell`

## Package layout

- `config`: files under `~/.config` (app/tool configuration).
- `local`: files under `~/.local` (mostly user scripts/assets meant to be shared).
- `shell`: top-level shell dotfiles (currently `~/.zshenv`).

## Add a new config (stow + git workflow)

1. Create/edit config in your home directory first, for example `~/.config/myapp/config.toml`.
2. Copy only stable config files into stow source: `packages/config/dot-config/myapp/`.
3. Add volatile patterns to `packages/config/.gitignore` (`cache/`, `state/`, `*.log`, plugin dirs, etc.).
4. Restow:
   `stow -d /home/anton/dotfiles/packages -t /home/anton --dotfiles --no-folding --restow config`
5. Verify links and runtime behavior:
   - config file should be symlinked from `~/.config/...` to `packages/config/...`
   - runtime files should land in `~/.cache`, `~/.local/state`, or `~/.local/share`, not in this repo
6. Commit only intentional config changes.

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
