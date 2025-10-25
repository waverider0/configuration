export PS1='%n@%m %F{#00ff77}%~%f :: '
export MANPAGER='nvim +Man!'

alias open='xdg-open'
alias vi='nvim'

bindkey -v
bindkey -M viins '^[[1;5D' backward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M viins '^H' backward-kill-word
bindkey -M viins '^[[3;5~' kill-word

setopt EXTENDED_GLOB
setopt GLOBDOTS
setopt NULL_GLOB
setopt MENU_COMPLETE
unsetopt LIST_AMBIGUOUS

zmodload zsh/complist
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'l:|=*'
