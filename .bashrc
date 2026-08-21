# Enhanced bash history
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T "
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
# Share history live across terminals
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Better directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Enhanced ls commands
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lr='ls -ltrh'
alias lk='ls -lSrh'
alias ld='ls -ltrh | grep "^d"'

# System commands
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i'
command -v htop >/dev/null 2>&1 && alias top='htop'

# Network commands
alias ports='netstat -tulanp'
alias myip='curl http://ipecho.net/plain; echo'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'

# Safety features
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# Custom aliases
alias py='python3'
alias jn='jupyter notebook'
alias fcd='cd "$(find . -type d | fzf)"'     # cd into selected dir
alias vf='nvim "$(fzf)"'                     # open selected file with nvim
alias fh='history | fzf'                     # fuzzy search bash history

# Extract function
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Git branch function
parse_git_branch() {
    git branch 2>/dev/null | sed -n '/\* /s///p' | awk '{print " (" $1 ")"}'
}

# Green prompt with git branch in yellow
export PS1='\[\e[0;32m\]\u@\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0;33m\]$(parse_git_branch)\[\e[0m\]\$ '

# Custom functions
mkcd() { mkdir -p "$1" && cd "$1"; }
cd() { builtin cd "$@" && ls; }

# Weather lookup
weather() {
    curl "wttr.in/${1:-}"
}

# Inline calculator
calc() {
    bc -l <<< "$@"
}

# System update function
update() {
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt clean
}

# Add local bin to PATH (deduped)
if [ -d "$HOME/.local/bin" ]; then
    case ":$PATH:" in
        *":$HOME/.local/bin:"*) ;;
        *) PATH="$HOME/.local/bin:$PATH" ;;
    esac
fi

# Bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Set default editor (keep EDITOR and VISUAL consistent)
export EDITOR='nvim'
export VISUAL='nvim'

# Colored man pages (single source of truth — used by `man`, `less`, etc.)
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'

# Load env file only if it exists
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
