#!/bin/bash
# Dependency list
# Author: Ali Hassani (@alihassanijr)
# NOTE: this should be sourced from ./dotfiles/


# Kitty 
source installer/dependencies/kitty.sh
ensure_kitty() {
  if [[ $IS_PERSONAL -eq 1 ]]; then
    check_and_install_dependency "kitty" "$(which kitty)" "install_kitty"
    configure_dependency "kitty" "configure_kitty"
  fi
}
