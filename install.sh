#!/bin/bash
# Installer script
# Author: Ali Hassani (@alihassanijr)

# Load functions
source installer/prolog.sh
source installer/utils.sh
source installer/deps.sh
source installer/configs.sh

assert_dotfiles_in_home

# Ensure submodules are cloned
update_submodules

# Ensure expected directories exist
ensure_local_exists

echo "Installing my stuff..."

# Build tools and utilities
ensure_cmake
ensure_ncurses
ensure_git_lfs

# Everyday
ensure_kitty            # terminal emulator (conditional dependency)
ensure_tmux             # window manager (conditional soft dependency)
ensure_vim              # editor
ensure_vifm             # file browser
ensure_zathura          # document viewer (conditional dependency)
ensure_zsh              # shell
ensure_oh_my_zsh        # extension to zsh

# Fancy alternatives
ensure_bat              # alternative to cat
ensure_diff_so_fancy    # alternative to diff
ensure_exa              # alternative to ls
ensure_htop             # alternative to top
ensure_rg               # alternative to grep
ensure_tre              # alternative to tree

# Not as frequently used, but nice to have
ensure_fzf              # Fuzzy finder


# Do the linking

link_base16colors
link_lscolors
link_inputrc
link_commonrc
link_bashrc

link_custom_scripts

echo "Installation complete."
