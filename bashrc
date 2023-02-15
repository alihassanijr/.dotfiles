#
# ~/.bashrc
#

if [[ "$OSTYPE" == "darwin"* ]]; then
    # If not running interactively, don't do anything
    [[ $- != *i* ]] && return

    bind -f  ~/.inputrc
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    source  ~/.inputrc
fi

export PATH="${PATH}:/opt"

source ~/.commonrc

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
