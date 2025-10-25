export PS1='%n@%m %F{#00ff77}%~%f :: ' # <name>@<hostname> <path> :: <command>
export MANPAGER='nvim +Man!'

alias open='xdg-open'
alias vi='nvim'

set -o vi
setopt EXTENDED_GLOB
setopt GLOBDOTS
setopt NULL_GLOB
