#!/bin/bash
# Installer script
# Author: Ali Hassani (@alihassanijr)

# Load functions
source installer/prolog.sh
if [[ $IS_PERSONAL -eq 1 ]]; then
  echo "This is a personal device, is that right? (will attempt to install terminal emulator and pdf viewer.)"
else
  echo "This is NOT a personal device, is that right? (will skip installing terminal emulator and pdf viewer.)"
fi
read
source installer/utils.sh
source installer/deps.sh
source installer/configs.sh

assert_dotfiles_in_home

# Ensure submodules are cloned
update_submodules

# Ensure expected directories exist
ensure_local_exists

echo "Installing my stuff..."

# Very basic stuff (usually installed on linux, but
# not necessarily on mac).
ensure_pkg_config
ensure_wget

# Build tools integral to other dependencies
ensure_m4
ensure_autoconf
ensure_automake
#ensure_perl

# Curses library
ensure_ncurses
ensure_gettext

# Utilities
ensure_coreutils
#ensure_make
ensure_cmake
ensure_git
ensure_git_lfs

# Cloudflare in case we need to tunnel certain
# ssh connections.
ensure_cloudflare

# Everyday
#ensure_kitty            # former terminal emulator (conditional dependency)
ensure_alacritty        # terminal emulator (conditional dependency)
ensure_tmux             # window manager (conditional soft dependency)
ensure_vim              # editor
ensure_vifm             # file browser
ensure_zathura          # document viewer (conditional dependency)
ensure_zsh              # shell

# Fancy alternatives
ensure_bat              # alternative to cat
ensure_diff_so_fancy    # alternative to diff
ensure_lsd              # alternative to ls
ensure_htop             # alternative to top
ensure_rg               # alternative to grep
ensure_tre              # alternative to tree

# Not as frequently used, but nice to have
ensure_aria2            # download utility
ensure_fzf              # Fuzzy finder
ensure_watch            # watch command

# Literally entertainment
ensure_cmatrix

# Do the linking

link_base16colors
link_lscolors
link_inputrc
link_commonrc
link_bashrc

link_custom_scripts

# Fix permissions
chmod -R 700 $LOCALDIR
chmod -R 700 $NCDIR

echo "Installation complete."
