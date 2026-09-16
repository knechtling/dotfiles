# nvim-native

An independent Neovim 0.12+ profile for Markdown, shell, YAML, JSON, and Python.

Launch: `NVIM_APPNAME=nvim-native nvim`

Uses native `vim.pack`, LSP configuration, completion, diagnostics, netrw, and
syntax highlighting. Plugins provide server definitions, formatting, schema
associations, Git signs, fuzzy search, Tokyo Night, wiki.vim, and Which-key.
First launch installs them using Git and generates
`nvim-pack-lock.json`; keep that lockfile with this configuration.

## Tools

Run `:NativeTools` to see dependencies. Tools on PATH take precedence; the existing
`~/.local/share/nvim/mason/bin` is a fallback on this machine. This profile does not
install or update Mason tools. On another machine, install the executables below
with the system package manager or your chosen tool manager:

- Markdown: marksman, prettier
- Shell: bash-language-server, shellcheck, shfmt
- YAML: yaml-language-server, prettier
- JSON/JSONC: vscode-json-language-server, prettier
- Python: pyright-langserver, ruff
- Search/plugins: ripgrep (`rg`), git

Restart after installing missing servers. Use `:checkhealth vim.lsp` and
`:ConformInfo` for troubleshooting. Activate a Python virtual environment before
launching, or configure it in the project. Schema associations belong in project
settings or `lua/native/lsp.lua`.

## Keys

Space is leader. `ff` finds files, `sg` searches text, `fb` switches buffers,
`fh` searches help, `e` opens netrw. `cf` formats explicitly (no format-on-save),
`cr` renames, `ca` offers code actions, `cd` explains diagnostics, `xx` lists them,
`ud` toggles them. Native `K`, `grr`, `[d`, and `]d` provide hover, references, and
diagnostic navigation. Use Ctrl-X Ctrl-O for manual LSP completion, Ctrl-N/P to
select a candidate and Ctrl-Y to accept. Toggle Markdown spelling
with `Space us`. Markdown spelling supports German and English; uncounted j/k
move by display line. Shift-h/l switch buffers, Space bb returns to the alternate
buffer, and Space bd closes the current buffer without discarding edits.
Space ff/sg use the nearest project root; Space cp shows roots and Python settings.
An activated environment or a project .venv supplies Pyright's interpreter.
Git buffers offer [c/]c for changes, Space gp to preview, Space gs to stage, and
Space gb for blame. JSON and YAML use SchemaStore associations.

Pause after Space (or another mapping prefix) for 250 ms to see Which-key's
available bindings. `Space ?` shows buffer-local mappings, including wiki
navigation when editing wiki pages. Escape closes the popup.

## Wiki

Uses the same `lervag/wiki.vim` plugin and `~/vimwiki/text/` root as the existing
Neovim profile. Wiki content is shared, not copied. `Space ww` opens the index,
`Space w Space w` opens the journal, and `Space wn` opens a page by name.
Inside wiki pages, Enter follows a link, Backspace returns to the previous page,
and Tab / Shift-Tab move between links. `Space wgb` finds backlinks and `Space wt`
generates a table of contents. See `:help wiki-mappings` for the full defaults.
Saving is now `Space fs` (or `:w`), leaving `Space w` free as the wiki prefix.
`Space wf` finds wiki pages and `Space ws` searches wiki text from any directory.
Wiki tags moved to `Space wT`, link transformation to `Space wF`, and local TOC
generation to `Space wO`.

`:NativeUpdate` opens native plugin update review; write to accept or quit to
discard, then restart. Updates are explicit. Plugin/data/state directories are
isolated by NVIM_APPNAME; existing LazyVim and vi profiles remain available.

This first version uses built-in syntax highlighting rather than installing
Treesitter parsers. It does not add rendered Markdown or image
previews yet. The configuration is deployed by the separate `nvim-native` Stow
package in ~/dotfiles/packages/nvim-native, including the native plugin lockfile.
