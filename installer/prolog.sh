#!/bin/bash
# Installer script prolog: global variables and such
# Author: Ali Hassani (@alihassanijr)

# Where should dotfiles be?
THISDIR=$HOME/.dotfiles

# Where is home?
HOMEDIR=$HOME

# Where should I install everything?
LOCALDIR=$HOME/.local/

# Curses is special; where do I install that?
NCDIR=$HOME/.ncurses/


# Whether or not this is a personal device 
## I want certain things like my terminal emulator only on
## personal devices, not on servers.
IS_PERSONAL=false
if [[ "$OSTYPE" == "darwin"* ]]; then
    IS_PERSONAL=true
fi
