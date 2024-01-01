
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac
    plugins=(history-substring-search colored-man-pages macos zsh-autosuggestions zsh-syntax-highlighting)
else
    # Linux Plugins
    plugins=(history-substring-search colored-man-pages zsh-autosuggestions zsh-syntax-highlighting)
fi


source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd
#bindkey -v
# Enable history search with up/down keys
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search
# End of lines configured by zsh-newuser-install
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

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Syntax colors
source ~/.config/zsh/zsh-syntax-highlighting.sh
source ~/.config/zsh/zsh-agnoster-custom.sh
