

#
# User configuration sourced by interactive shells
#

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

# Environment variable configuration
export PATH=$HOME/.nodebrew/current/bin:$PATH
export LANG=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8

# command correct edition before each completion attempt
setopt correct

# auto directory pushed that you can get dirs list by cd -[tab]
setopt auto_pushd

# Enable completion
autoload -U compinit
compinit

# History configuration
HISTSIZE=1000
SAVEHIST=10000

# Keybind
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
