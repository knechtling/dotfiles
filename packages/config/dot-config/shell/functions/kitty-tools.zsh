# Kitty helpers. Loaded automatically by ~/.config/zsh/.zshrc.

alias icat='kitten icat'
alias kssh='kitten ssh'
alias ktheme='kitten themes'

# Run a command and send a desktop notification when it completes.
knotify() {
    if (( $# == 0 )); then
        print -u2 'usage: knotify command [argument ...]'
        return 2
    fi

    local started=$EPOCHSECONDS
    "$@"
    local status=$?
    local elapsed=$(( EPOCHSECONDS - started ))
    local title='Command finished'
    (( status == 0 )) || title='Command failed'
    kitten notify --icon utilities-terminal "$title" \
        "exit $status after ${elapsed}s: ${(q-)@}"
    return $status
}

# Copy stdin/text or retrieve clipboard content through Kitty, including SSH.
kcopy() { kitten clipboard "$@" }
kpaste() { kitten clipboard --get-clipboard }

# Launch yazi and adopt its final directory.
y() {
    local tmp cwd
    tmp="$(mktemp -t 'yazi-cwd.XXXXXX')" || return

    if (( $+commands[yazi] )); then
        command yazi --cwd-file="$tmp" "$@"
        cwd="$(<"$tmp")"
    else
        print -u2 'yazi is not installed.'
        command rm -f -- "$tmp"
        return 127
    fi

    command rm -f -- "$tmp"
    [[ -n "$cwd" && "$cwd" != "$PWD" && -d "$cwd" ]] && builtin cd -- "$cwd"
}
