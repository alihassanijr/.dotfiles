#!/bin/bash
# Dependency list
# Author: Ali Hassani (@alihassanijr)
# NOTE: this should be sourced from ./dotfiles/

# Alacritty
source installer/dependencies/alacritty.sh
ensure_alacritty() {
  if [[ -f "$(which $DEP_NAME)" ]]; then
    echo "Looks like you have alacritty installed."
    configure_dependency "alacritty" "configure_alacritty"
  fi
}

# Aria2
source installer/dependencies/aria2.sh
ensure_aria2() {
  check_and_install_dependency "aria2" "$LOCALDIR/bin/aria2c" "install_aria2"
}

# Autoconf
source installer/dependencies/autoconf.sh
ensure_autoconf() {
  check_and_install_hard_dependency "autoconf" "install_autoconf"
}

# Automake
source installer/dependencies/automake.sh
ensure_automake() {
  check_and_install_hard_dependency "automake" "install_automake"
}

# Bat
source installer/dependencies/bat.sh
ensure_bat() {
  check_and_install_hard_dependency "bat" "install_bat"
  configure_dependency "bat" "configure_bat"
}

# cloudflare
source installer/dependencies/cloudflare.sh
ensure_cloudflare() {
  check_and_install_hard_dependency "cloudflared" "install_cloudflare"
}

# CMake
source installer/dependencies/cmake.sh
ensure_cmake() {
  check_and_install_dependency "cmake" "$LOCALDIR/bin/cmake" "install_cmake"
}

# cmatrix
source installer/dependencies/cmatrix.sh
ensure_cmatrix() {
  check_and_install_dependency "cmatrix" "$LOCALDIR/bin/cmatrix" "install_cmatrix"
}

# coreutils
source installer/dependencies/coreutils.sh
ensure_coreutils() {
  check_and_install_dependency "coreutils" "$LOCALDIR/extras/coreutils/bin/cp" "install_coreutils"
}

# Diff-so-fancy
source installer/dependencies/diff-so-fancy.sh
ensure_diff_so_fancy() {
  check_and_install_dependency "diff-so-fancy" "$LOCALDIR/bin/diff-so-fancy" "install_diff_so_fancy"
  configure_dependency "diff-so-fancy" "configure_diff_so_fancy"
}

# Fzf
source installer/dependencies/fzf.sh
ensure_fzf() {
  check_and_install_dependency "fzf" "$HOMEDIR/.fzf/bin/fzf" "install_fzf"
}

# gettext
source installer/dependencies/gettext.sh
ensure_gettext() {
  # Don't trust OS's gettext, because it may not have autopoint.
  # check_and_install_hard_dependency "gettext" "install_gettext"
  check_and_install_dependency "gettext" "$LOCALDIR/bin/gettext" "install_gettext"
}

# Git-lfs
source installer/dependencies/git-lfs.sh
ensure_git_lfs() {
  check_and_install_dependency "git-lfs" "$LOCALDIR/bin/git-lfs" "install_git_lfs"
}

# Htop
source installer/dependencies/htop.sh
ensure_htop() {
  check_and_install_dependency "htop" "$LOCALDIR/bin/htop" "install_htop"
  configure_dependency "htop" "configure_htop"
}

# LSD
source installer/dependencies/lsd.sh
ensure_lsd() {
  check_and_install_hard_dependency "lsd" "install_lsd"
}

# M4
source installer/dependencies/m4.sh
ensure_m4() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # Don't use mac's m4
    check_and_install_dependency "m4" "$LOCALDIR/bin/m4" "install_m4"
  else
    check_and_install_hard_dependency "m4" "install_m4"
  fi
}

# NCurses
source installer/dependencies/ncurses.sh
ensure_ncurses() {
  check_and_install_dependency "ncurses" "$NCDIR/bin/ncursesw6-config" "install_ncurses"
}

# Oh-My-ZSH
source installer/dependencies/oh-my-zsh.sh
ensure_oh_my_zsh() {
  check_and_install_dependency "Oh My ZSH" "$HOMEDIR/.oh-my-zsh/oh-my-zsh.sh" "install_oh_my_zsh"
  configure_dependency "oh_my_zsh" "configure_oh_my_zsh"
}

# pkg-config
source installer/dependencies/pkg_config.sh
ensure_pkg_config() {
  check_and_install_hard_dependency "pkg-config" "install_pkg_config"
}

# Ripgrep
source installer/dependencies/rg.sh
ensure_rg() {
  check_and_install_hard_dependency "rg" "install_rg"
}

# Tmux
source installer/dependencies/tmux.sh
ensure_tmux() {
  #if [[ $IS_PERSONAL -eq 0 ]]; then
    # check_and_install_dependency "tmux" "$LOCALDIR/bin/tmux" "install_tmux"
    check_and_install_hard_dependency "tmux" "install_tmux"
    configure_dependency "tmux" "configure_tmux"
  #fi
}

# Tre
source installer/dependencies/tre.sh
ensure_tre() {
  check_and_install_hard_dependency "tre" "install_tre"
}

# Vim
source installer/dependencies/vim.sh
ensure_vim() {
  check_and_install_dependency "vim" "$LOCALDIR/bin/vim" "install_vim"
  configure_dependency "vim" "configure_vim"
}

# Vifm
source installer/dependencies/vifm.sh
ensure_vifm() {
  check_and_install_dependency "vifm" "$LOCALDIR/bin/vifm" "install_vifm"
  configure_dependency "vifm" "configure_vifm"
}

# watch
source installer/dependencies/watch.sh
ensure_watch() {
  check_and_install_hard_dependency "watch" "install_watch"
}

# wget
source installer/dependencies/wget.sh
ensure_wget() {
  check_and_install_hard_dependency "wget" "install_wget"
  configure_wget
}

# Zathura
source installer/dependencies/zathura.sh
ensure_zathura() {
  if [[ $IS_PERSONAL -eq 1 ]]; then
    check_and_install_dependency "zathura" "$(which zathura)" "install_zathura"
    configure_dependency "zathura" "configure_zathura"
  fi
}

# ZSH
source installer/dependencies/zsh.sh
ensure_zsh() {
  check_hard_dependency "zsh"
  configure_dependency "zsh" "configure_zsh"
}
