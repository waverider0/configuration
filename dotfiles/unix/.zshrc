export PS1='%n@%m:%F{#00ff77}%~%f$ '
export EDITOR=nvim
export MANPAGER='nvim +Man!'

alias code='codium'
alias open='xdg-open'
alias vi='nvim'
alias zed='zeditor'

setopt EXTENDED_GLOB
setopt GLOBDOTS
setopt NULL_GLOB

bindkey -v
bindkey -M viins '^[[1;5D' backward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M viins '^H' backward-kill-word
bindkey -M viins '^[[3;5~' kill-word

zmodload zsh/complist
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'l:|=*'

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey -M vicmd '^[[A' history-beginning-search-backward-end '^[OA' history-beginning-search-backward-end '^[[B' history-beginning-search-forward-end '^[OB' history-beginning-search-forward-end
bindkey -M viins '^[[A' history-beginning-search-backward-end '^[OA' history-beginning-search-backward-end '^[[B' history-beginning-search-forward-end '^[OB' history-beginning-search-forward-end

fvi() {
  local file
  file=$(find . -type f | fzf)
  [[ -n $file ]] && vi -- "$file"
}

zle -N fvi
bindkey '^P' fvi
