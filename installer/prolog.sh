#!/bin/bash
# Installer script prolog: global variables and such
# Author: Ali Hassani (@alihassanijr)

# Where should dotfiles be?
THISDIR=$HOME/.dotfiles

# Where is home?
HOMEDIR=$HOME

# Where should I install everything?
PROGRAMS_PATH=${PROGRAMS_PATH:-$HOME}

LOCALDIR=$PROGRAMS_PATH/.local/
NCDIR=$PROGRAMS_PATH/.ncurses/
FZF_DIR=$PROGRAMS_PATH
BREWDIR=$PROGRAMS_PATH/.brew


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
if [[ "$_OS_NAME" == "darwin" ]]; then
    IS_PERSONAL=1
fi

# When set to 1, only build/install dependencies and skip all configuration.
BUILD_ONLY=${BUILD_ONLY:-0}

PYTHON_BASE_VENV_DIR=$PROGRAMS_PATH/.python-base
UV_PYTHON_INSTALL_DIR_DEFAULT=$PROGRAMS_PATH/.uv-python
export UV_PYTHON_INSTALL_DIR=${UV_PYTHON_INSTALL_DIR:-$UV_PYTHON_INSTALL_DIR_DEFAULT}
