#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [[ "$OSTYPE" == "darwin"* ]]; then
    bind -f  ~/.inputrc
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    source  ~/.inputrc
fi

export PATH="${PATH}:/opt"

source ~/.commonrc

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
