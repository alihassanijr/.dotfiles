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


_OS_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$_OS_NAME" == "linux" || "$_OS_NAME" == "darwin" ]] \
  || { printf 'Error: unsupported OS: %s\n' "$_OS_NAME" >&2; exit 1; }

_ARCH=$(uname -m)

echo "OS: $_OS_NAME"
echo "Arch: $_ARCH"

# Whether or not this is a personal device 
## I want certain things like my terminal emulator only on
## personal devices, not on servers.
IS_PERSONAL=0
if [[ "$OS_NAME" == "darwin" ]]; then
    IS_PERSONAL=1
fi
