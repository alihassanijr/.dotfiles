#!/bin/bash
# Homebrew

BREW_VERSION="6.0.0"

install_brew() {
  echo "Installing brew"
  rm -rf $BREWDIR
  git clone https://github.com/homebrew/brew $BREWDIR && \
      git -C $BREWDIR checkout $BREW_VERSION

  if [ $? -ne 0 ]; then
      echo "brew install failed."
      rm -rf $BREWDIR
      return 1
  fi
}
