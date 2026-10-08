#!/usr/bin/env bash
# Installer script
# Author: Ali Hassani (@alihassanijr)

source installer/prolog.sh
source installer/colors.sh
source installer/logo.sh

echo ""
print_logo
echo ""
print_info
echo ""

if [[ -n "$MAX_WORKERS" && $NUM_WORKERS -gt $MAX_WORKERS ]]; then
  err "You're exceeding nproc: $NUM_WORKERS > $MAX_WORKERS."
  exit 1
fi

if [[ "$BUILD_ONLY" -ne 1 ]]; then
  warn "Please confirm the details above, then press ENTER to proceed."
  read
fi

source installer/utils.sh
source installer/deps.sh
source installer/configs.sh
source installer/permissions.sh

assert_dotfiles_in_home

# Ensure expected directories exist
ensure_local_exists

echo "Building / linking stuff..."

# .brew
# expose brew path ONLY when using brew to build.
# we don't want the rest of our dependencies to link with stuff installed by brew
#export PATH=$BREWDIR/bin:$BREWDIR/sbin:$PATH
if [[ $PATH == *brew* ]]; then
  warn "WARNING: brew detected in PATH. Will attempt to remove."
  warn "Brew's own pkg-config will usually conflict with our own and break the install, so it's"
  warn "highly recommended to remove it when building programs locally."
  echo ""
  if [[ "$BUILD_ONLY" -eq 1 ]]; then
    echo "PATH=$PATH"
    err "ERROR: Will NOT proceed with BUILD_ONLY run."
    err "Please ensure PATH is untouched during BUILD_ONLY."
    exit 1
  fi
  remove_brew_from_path
fi


# base python env (uv)
export PATH=$PYTHON_BASE_VENV_DIR/bin:$PATH

# .local
export PATH=$LOCALDIR/bin:$PATH
export LD_LIBRARY_PATH=$LOCALDIR/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export PKG_CONFIG_PATH="$LOCALDIR/lib/pkgconfig:$PKG_CONFIG_PATH"
export ACLOCAL_PATH="$LOCALDIR/share/aclocal${ACLOCAL_PATH:+:$ACLOCAL_PATH}"

# .ncurses
export LD_LIBRARY_PATH=$NCDIR/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export PKG_CONFIG_PATH="$NCDIR/lib/pkgconfig:$PKG_CONFIG_PATH"
export CFLAGS="-I$NCDIR/include -I$NCDIR/include/ncursesw $CFLAGS"
export CPPFLAGS="-I$NCDIR/include -I$NCDIR/include/ncursesw $CPPFLAGS"

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
ensure_jq

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
ensure_fancy_smi        # alternative to nvidia-smi

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
  fix_permissions

else
  dim "BUILD_ONLY set; skipping config linking."
fi

echo ""
print_done
echo ""
