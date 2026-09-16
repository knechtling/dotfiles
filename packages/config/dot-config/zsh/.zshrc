# Anton's config for the Zoomer Shell

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors

# Enable prompt substitution
setopt prompt_subst
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'

# Git status function for prompt

PS1=$'%F{blue}%~%f %F{magenta}${vcs_info_msg_0_}%f %F{green}➜%f\u00A0'
# PROMPT=$'%F{blue}%~%f %F{magenta}$(__git_ps1 " (%s)")%f %F{green}➜%f\u00A0'


setopt autocd			# Automatically cd into typed directory.
[[ -t 0 ]] && stty stop undef	# Disable ctrl-s flow control on terminals.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
setopt extended_history
setopt share_history
setopt append_history
setopt hist_ignore_space
setopt hist_reduce_blanks

# Load profile first so all env vars are ready
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/profile" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/profile"
# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"
# Load functions
for f in "${XDG_CONFIG_HOME:-$HOME/.config}/shell/functions/"*(N); do source "$f"; done

ZINIT_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zinit/bin"
if [[ -s "$ZINIT_HOME/zinit.zsh" ]]; then
	source "$ZINIT_HOME/zinit.zsh"
	zinit light zsh-users/zsh-completions
fi

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n "$ZSH_COMPDUMP"(#qN.mh+24) ]]; then
	compinit -d "$ZSH_COMPDUMP"
else
	compinit -C -d "$ZSH_COMPDUMP"
fi
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use yazi to switch directories and bind it to ctrl-g
bindkey -s '^g' '^uy\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-x:
autoload edit-command-line; zle -N edit-command-line
bindkey '^x' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete


# Implement emacs keybindings in vi mode
bindkey "^a" vi-beginning-of-line
bindkey "^e" vi-end-of-line
bindkey "^u" backward-kill-line
bindkey "^k" kill-line
bindkey "^w" backward-kill-word
bindkey "^r" history-incremental-search-backward
bindkey "^[b" backward-word
bindkey "^[f" forward-word
bindkey "^[d" kill-word
bindkey "^l" clear-screen
bindkey "^_" undo

# Override default vi mode behavior for ESC + . to repeat last argument (like bash)
bindkey '\e.' insert-last-word

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# Dirstack configuration
autoload -Uz add-zsh-hook
DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"
if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
	dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
	[[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi
chpwd_dirstack() {
	print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd chpwd_dirstack
DIRSTACKSIZE='100'
setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

# Add cheat.sh completion
fpath=(~/.config/zsh/ $fpath)

## Load plugins; should be last.

if [[ -s "$ZINIT_HOME/zinit.zsh" ]]; then
	zinit light Aloxaf/fzf-tab

	ZSH_AUTOSUGGEST_STRATEGY=(history completion)
	zinit light zsh-users/zsh-autosuggestions
	zinit light agkozak/zsh-z
	zinit light joshskidmore/zsh-fzf-history-search
	zinit light sunlei/zsh-ssh

	# Extend zsh-ssh's fzf picker to wrapped SSH commands while preserving
	# the command form the user typed.
	functions[_fzf_complete_ssh_bare]=$functions[fzf_complete_ssh]
	_set_lbuffer() {
		local result="$1" is_fzf_result="$2" selected_host
		if [[ "$is_fzf_result" == false ]]; then
			result=$(cut -f 1 -d '|' <<< "$result")
		fi
		selected_host=$(cut -f 1 -d ' ' <<< "$result")
		LBUFFER="${_fzf_ssh_command_prefix:-ssh }${selected_host}"
	}
	fzf_complete_ssh() {
		_fzf_ssh_command_prefix='ssh '
		case "$LBUFFER" in
			(tsocks\ kitten\ ssh*) _fzf_ssh_command_prefix='tsocks kitten ssh '; LBUFFER="ssh ${LBUFFER#tsocks kitten ssh}" ;;
			(tsocks\ kssh*)       _fzf_ssh_command_prefix='tsocks kssh ';       LBUFFER="ssh ${LBUFFER#tsocks kssh}" ;;
			(tsocks\ ssh*)        _fzf_ssh_command_prefix='tsocks ssh ';        LBUFFER="${LBUFFER#tsocks }" ;;
			(kitten\ ssh*)        _fzf_ssh_command_prefix='kitten ssh ';        LBUFFER="ssh ${LBUFFER#kitten ssh}" ;;
			(kssh*)               _fzf_ssh_command_prefix='kssh ';              LBUFFER="ssh ${LBUFFER#kssh}" ;;
		esac
		_fzf_complete_ssh_bare
		unset _fzf_ssh_command_prefix
	}
	zle -N fzf_complete_ssh
	bindkey '^I' fzf_complete_ssh
	zinit light zdharma-continuum/fast-syntax-highlighting
else
	print -u2 "Zinit not found at $ZINIT_HOME"
fi

compdef _precommand tsocks
compdef _ssh kssh
# Load aliases
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
