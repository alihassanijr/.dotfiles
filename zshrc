
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Mini oh my zsh
source ~/.config/zsh/mini-omz/mini-omz.sh

# Plugins
source ~/.config/zsh/mini-omz/plugins/colored-man-pages/colored-man-pages.plugin.zsh

source ~/.config/zsh/mini-omz/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.config/zsh/mini-omz/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

source ~/.config/zsh/mini-omz/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-syntax-highlighting-custom-colors.sh

###############################################################
# Histfile mods
###############################################################

if [[ -n $HISTFILE_OVERRIDE ]]; then
  HISTFILE=$HISTFILE_OVERRIDE
else
  HISTFILE=~/.histfile
fi

HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd

###############################################################
###############################################################
###############################################################

# Enable history search with up/down keys
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

###############################################################
# Load in Common RC file
###############################################################

source ~/.commonrc

###############################################################
###############################################################
###############################################################

###############################################################
# (Customized) Agnoster theme
###############################################################

# Timeout (seconds) for git prompt in the agnoster theme
export OMZ_GIT_TIMEOUT=1

# Maximum character lengths for prompt segments (incl. ellipsis marker)
export OMZ_MAX_USER_LENGTH=10
export OMZ_MAX_HOST_LENGTH=10
export OMZ_MAX_GIT_REF_LENGTH=20
export OMZ_MAX_DIR_LENGTH=30
export OMZ_MAX_CMD_LENGTH=50   # last command shown in the tmux pane title

# Move some segments (user/host/gpu/nproc/arch) into the tmux pane title when
# inside tmux. Set to 0 to disable: everything renders inline as before.
export OMZ_TMUX_TITLE=1


# Stock theme + our extensions (segments, routing, tmux title). The loader
# sources everything in order; GPU detection lives in agnoster-ext/sysinfo.sh.
source ~/.config/zsh/agnoster-ext/init.sh

###############################################################
###############################################################
###############################################################

if [[ "$OSTYPE" == "darwin"* ]]; then
    export TERM=alacritty
else
    export TERM=xterm-256color
fi
