#!/usr/bin/env bash
# Installer script prolog: global variables and such
# Author: Ali Hassani (@alihassanijr)


####################################################################################################
############################################# OS & ARCH ############################################
####################################################################################################
# TODO: duplicated from commonrc
distro_name() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    id=macos
    ver=$(sw_vers -productVersion 2>/dev/null | cut -d. -f1)
  elif [[ -r /etc/os-release ]]; then
    . /etc/os-release
    id=${ID:-linux}
    ver=${VERSION_ID:-rolling}
  fi
  id=${id:-linux}
  ver=${ver:-rolling}

  ver=$(printf '%s' "$ver" | tr -cd '0-9A-Za-z')
  printf '%s_%s\n' "$id" "$ver"
}
DISTRO_NAME=$(distro_name)

_OS_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$_OS_NAME" == "linux" || "$_OS_NAME" == "darwin" ]] \
  || { printf 'Error: unsupported OS: %s\n' "$_OS_NAME" >&2; exit 1; }

_ARCH=$(uname -m)

####################################################################################################
############################################### PATHS ##############################################
####################################################################################################

# Where should dotfiles be?
THISDIR=$HOME/.dotfiles

# Where is home?
HOMEDIR=$HOME

# Programs path default
# example: /home/$USER/.programs/ubuntu_2404_arm64
PROGRAMS_PATH_DEFAULT="$HOME/.programs/${DISTRO_NAME}_$(uname -m | sed 's/^aarch64$/arm64/')"

# Where should I install everything?
PROGRAMS_PATH=${PROGRAMS_PATH:-$PROGRAMS_PATH_DEFAULT}

# .local
LOCALDIR=$PROGRAMS_PATH/.local/

# .ncurses
NCDIR=$PROGRAMS_PATH/.ncurses/

# .fzf
FZF_DIR=$PROGRAMS_PATH

# .brew
BREWDIR=$PROGRAMS_PATH/.brew

# uv & base python venv
# uv python install dir: .uv-python
# base python venv: .python-base
PYTHON_BASE_VENV_DIR=$PROGRAMS_PATH/.python-base
UV_PYTHON_INSTALL_DIR_DEFAULT=$PROGRAMS_PATH/.uv-python
export UV_PYTHON_INSTALL_DIR=${UV_PYTHON_INSTALL_DIR:-$UV_PYTHON_INSTALL_DIR_DEFAULT}

####################################################################################################
######################################### PERSONAL v REMOTE ########################################
####################################################################################################

# Personal devices will have latex plugin for vim, prompt to install zathura (pdf viewer), link
# terminal emulator configs, etc.
IS_PERSONAL_DEFAULT=0
if [[ "$_OS_NAME" == "darwin" ]]; then
    IS_PERSONAL_DEFAULT=1
fi
IS_PERSONAL=${IS_PERSONAL:-$IS_PERSONAL_DEFAULT}

####################################################################################################
############################################## WORKERS #############################################
####################################################################################################

# First figure out max workers
MAX_WORKERS=""
if command -v nproc >/dev/null 2>&1; then
  MAX_WORKERS=$(nproc)
elif [[ "$_OS_NAME" == "darwin" ]]; then
  MAX_WORKERS=$(sysctl -n hw.logicalcpu 2>/dev/null)
fi

# Default NUM_WORKERS is max(1, MAX_WORKERS / 4)
NUM_WORKERS_DEFAULT=$((MAX_WORKERS/4))
[ $NUM_WORKERS_DEFAULT -le 0 ] && NUM_WORKERS_DEFAULT=1

NUM_WORKERS=${NUM_WORKERS:-$NUM_WORKERS_DEFAULT}

####################################################################################################
############################################ OTHER KNOBS ###########################################
####################################################################################################

# When set to 1, only build/install dependencies and skip all configuration.
BUILD_ONLY=${BUILD_ONLY:-0}
