
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Mini oh my zsh
source ~/.config/zsh/mini-omz/mini-omz.sh

# (Customized) Agnoster theme
source ~/.config/zsh/mini-omz/themes/agnoster.zsh-theme
source ~/.config/zsh/zsh-agnoster-custom.sh

# Plugins
source ~/.config/zsh/mini-omz/plugins/colored-man-pages/colored-man-pages.plugin.zsh

source ~/.config/zsh/mini-omz/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.config/zsh/mini-omz/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

source ~/.config/zsh/mini-omz/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-syntax-highlighting-custom-colors.sh

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd
#bindkey -v

# Enable history search with up/down keys
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

# TODO: unused?
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit
# End of lines added by compinstall


source ~/.commonrc

if [[ "$OSTYPE" == "darwin"* ]]; then
    export TERM=alacritty
else
    export TERM=xterm-256color
fi
