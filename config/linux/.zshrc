export PS1='%n@%m %F{#00ff77}%~%f :: ' # <name>@<hostname> <path> :: <command>
export MANPAGER='nvim +Man!'

alias open='xdg-open'
alias vi='nvim'

set -o vi
setopt EXTENDED_GLOB
setopt GLOBDOTS
setopt NULL_GLOB

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'l:|=*'

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey -M vicmd '^[[A' history-beginning-search-backward-end '^[OA' history-beginning-search-backward-end '^[[B' history-beginning-search-forward-end '^[OB' history-beginning-search-forward-end
bindkey -M viins '^[[A' history-beginning-search-backward-end '^[OA' history-beginning-search-backward-end '^[[B' history-beginning-search-forward-end '^[OB' history-beginning-search-forward-end
