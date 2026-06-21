#!/usr/bin/env bash
# Installer script
# Author: Ali Hassani (@alihassanijr)

echo "#====================#"
echo "#   Ali's dotfiles   #"
echo "#====================#"

echo "Building dotfiles with $NUM_WORKERS workers"

MAX_WORKERS=""
if command -v nproc >/dev/null 2>&1; then
  MAX_WORKERS=$(nproc)
elif [[ "$(uname -s)" == "Darwin" ]]; then
  MAX_WORKERS=$(sysctl -n hw.logicalcpu 2>/dev/null)
fi

if [[ -n "$MAX_WORKERS" && $NUM_WORKERS -gt $MAX_WORKERS ]]; then
  echo "You're exceeding nproc: $NUM_WORKERS > $MAX_WORKERS."
  exit 1
fi

# Load functions
source installer/prolog.sh
echo "Target directory for programs: $PROGRAMS_PATH"

if [[ "$BUILD_ONLY" -ne 1 ]]; then
  if [[ $IS_PERSONAL -eq 1 ]]; then
    echo "This is a GUI device, is that right? (will attempt to install terminal emulator and pdf viewer.)"
  else
    echo "This is NOT a GUI device, is that right? (will skip installing terminal emulator and pdf viewer.)"
  fi
  read
fi

source installer/utils.sh
source installer/deps.sh
source installer/configs.sh

assert_dotfiles_in_home

# Ensure submodules are cloned
update_submodules

# Ensure expected directories exist
ensure_local_exists

echo "Installing my stuff..."

# .brew
# expose brew path ONLY when using brew to build.
# we don't want the rest of our dependencies to link with stuff installed by brew
#export PATH=$BREWDIR/bin:$BREWDIR/sbin:$PATH
if [[ $PATH == *brew* ]]; then
  echo "WARNING: brew detected in PATH. Will attempt to remove"
  echo "PATH=$PATH"
  echo ""
  if [[ "$BUILD_ONLY" -eq 1 ]]; then
    echo "ERROR: Will NOT proceed with BUILD_ONLY run."
    echo "Please ensure PATH is untouched during BUILD_ONLY."
    exit 1
  fi
  {
    set -o pipefail
    if NEW_PATH="$(awk -v RS=: -v ORS=: '!/brew/' <<<"$PATH" | sed 's/:$//')"; then
      echo ""
      echo "PATH updated to $NEW_PATH"
      echo ""
      echo "Please confirm by pressing ENTER"
      read
      export PATH=$NEW_PATH
    else
      echo "Failed to correct path!"
      echo "Please exclude brew from path and try again!"
      exit 1
    fi
  }
fi


# .local
export PATH=$LOCALDIR/bin:$PATH
export LD_LIBRARY_PATH=$LOCALDIR/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export PKG_CONFIG_PATH="$LOCALDIR/lib/pkgconfig:$PKG_CONFIG_PATH"
export ACLOCAL_PATH="$LOCALDIR/share/aclocal${ACLOCAL_PATH:+:$ACLOCAL_PATH}"

# .ncurses
export LD_LIBRARY_PATH=$NCDIR/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export PKG_CONFIG_PATH="$NCDIR/lib/pkgconfig:$PKG_CONFIG_PATH"
export CFLAGS="-I$NCDIR/include -I$NCDIR/include/ncursesw"
export CPPFLAGS="-I$NCDIR/include -I$NCDIR/include/ncursesw"


# git, brew, and uv first; other dependencies may rely on them.
ensure_git
ensure_brew
ensure_uv

# Very basic stuff (usually installed on linux, but
# not necessarily on mac).
ensure_make
ensure_pkg_config
ensure_wget

# Build tools integral to other dependencies
ensure_m4
ensure_autoconf
ensure_automake

# Curses library
ensure_ncurses
ensure_gettext

# Utilities
ensure_coreutils
ensure_gnu_awk
ensure_gnu_grep
ensure_gnu_sed
ensure_watch
ensure_cmake
ensure_git_lfs
ensure_parallel

# Everyday
ensure_clang_format
ensure_alacritty
ensure_tmux
ensure_vim
ensure_vifm
ensure_bash
ensure_zsh
ensure_fzf

# Coding agents
ensure_claude
ensure_codex

# Fancy alternatives
ensure_bat              # alternative to cat
ensure_diff_so_fancy    # alternative to diff
ensure_lsd              # alternative to ls
ensure_htop             # alternative to top
ensure_rg               # alternative to grep
ensure_tre              # alternative to tree

# GUIs and other misc stuff
ensure_zathura
ensure_cmatrix

# Custom scripts
link_custom_scripts

# Link configs and whatnot
if [[ "$BUILD_ONLY" -ne 1 ]]; then
  link_base16colors
  link_lscolors
  link_inputrc
  link_commonrc
  link_bashrc
  link_git_config
  link_fzf
  link_agentfiles

  # Fix permissions
  chmod 700 $LOCALDIR
  chmod 700 $NCDIR

  # Just for being safe
  chmod 700 $HOME/.ssh

else
  echo "BUILD_ONLY set; skipping config linking."
fi

echo "Installation complete."
