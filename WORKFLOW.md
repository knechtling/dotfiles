# Terminal and editor workflow

## Deployment

Run `make dry-run` before deployment. `nvim-native` is a separate Stow package, so
it can be deployed without touching other desktop settings:

    stow -d packages -t "$HOME" --dotfiles --no-folding nvim-native

Kitty's configuration lives inside the `config` package, under
`packages/config/dot-config/kitty/`.

The existing config package has local conflicts in mimeapps.list and
user-dirs.dirs. Compare those files with their repository counterparts before a
full restow; do not use --adopt blindly. `make check` checks shell and Lua syntax.

## Zsh and Kitty

Shell plugins are managed by zinit. Ctrl-r uses fzf history search in insert and
command mode. Atuin is no longer initialized; its data is retained. The existing history file and size are retained.
New shells preserve their requested working directory. `cdr` explicitly restores
the last saved directory. `knotify command ...` returns the command's exit code.

Kitty is the default local terminal. Ctrl-Shift-Enter opens a window in the current
directory; Ctrl-Shift-t opens a tab. Use tmux for persistent work or on remote
hosts. Kitty's scrollback pager uses a minimal Neovim session. SSH remote-control
forwarding remains disabled. Clipboard reads retain Kitty's confirmation prompt.

## tmux (prefix Ctrl-b)

- c: new window; v / %: side-by-side split; s / ": stacked split
- h/j/k/l: select pane; H/J/K/L: resize; z: zoom
- [: copy mode; v: select; y: copy and leave; Escape: cancel
- ]: paste tmux buffer; mouse selection copies without clearing selection
- Ctrl-s: save session; Ctrl-r: restore session manually
- r: reload config; d: detach; w: window picker

Continuum saves every 15 minutes while its status hook runs. Automatic restore
and boot are off. Pane contents are included as in the existing configuration.
Resurrect does not checkpoint process memory; restoration may relaunch supported
commands. TPM loads from /usr/share/tmux-plugin-manager/tpm or ~/.tmux/plugins/tpm/tpm.
On a new host install TPM there, then prefix I to install the listed plugins.
Continuum must remain last in the plugin list, after the status theme.

Clipboard uses tmux's OSC 52 support, including through SSH when the terminal
supports it. Local/remote terminals need tmux-256color terminfo. Verify graphical
clipboard paste and modified keys in a real Kitty window after reloading.

## nvim-native

Launch `NVIM_APPNAME=nvim-native nvim`; the default editor is unchanged.
Shift-h/l switch buffers, Space bb alternates, Space bd closes (without forcing).
Space ff/sg search the nearest project; Space wf/ws always search the wiki.
Wiki tags live under Space wT; link transformation is Space wF; local TOC is
Space wO. Space wt still generates the full TOC.

Markdown j/k follow display lines unless prefixed by a count; Space us toggles
German/English spelling and z= offers corrections. Formatting stays manual.
Space cp reports search/LSP roots and Python environment. Activated virtualenvs
take precedence, then project .venv; otherwise Pyright performs its own discovery.
SchemaStore supplies JSON/YAML associations; custom schemas can be configured in
lua/native/lsp.lua or YAML language-server modelines.

Git: [c / ]c previous/next change, Space gp preview, Space gs stage the current
change, Space gb blame. These bindings are buffer-local for Git-tracked files.

Dependencies: Neovim >=0.12, git, rg, fzf, yazi, Kitty, tmux >=3.3, Zsh, GNU Stow,
Zinit and the declared shell/tmux plugins. NativeTools reports language tools;
the existing Mason bin directory is used only as a fallback. Plugin versions
are stored in nvim-pack-lock.json. NativeUpdate explicitly reviews updates.

## Verification after restart

Open a Kitty window in a project, create tmux splits, and confirm pwd stays there.
Try Ctrl-r and cancel with Escape without executing a command. Select harmless
text in tmux and paste into another application; repeat on a remote host.
Save/restore a disposable tmux session manually before relying on restoration.
Inspect NativeProject, ConformInfo and checkhealth vim.lsp in representative files.
