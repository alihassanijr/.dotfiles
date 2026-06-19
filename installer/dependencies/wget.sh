#!/bin/bash
# wget

install_wget() {
  if [[ "$BUILD_ONLY" -eq 1 ]]; then
    echo "Skip wget in BUILD_ONLY -- only build option is brew, and "
    echo "brew installs shouldn't be shipped. Install at runtime."
    return 0
  fi

  echo "Installing wget via brew"
  brew install wget
}
