#!/bin/bash
# Zathura
# Document viewer

install_zathura() {
  if [[ "$BUILD_ONLY" -eq 1 ]]; then
    echo "Skip zathura in BUILD_ONLY -- only build option is brew, and "
    echo "brew installs shouldn't be shipped. Install at runtime."
    return 0
  fi

  echo "I can only install Zathura via homebrew."
  echo "If you don't have homebrew, I'll install it locally and without root!"
  echo "Do you want to proceed?"
  read -p "Install Zathura via homebrew () [y/n]: " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    ensure_brew

    brew tap zegervdv/zathura
    brew install zathura
    brew install zathura-pdf-poppler

    mkdir -p $(brew --prefix zathura)/lib/zathura

    ln -s \
      $(brew --prefix zathura-pdf-poppler)/libpdf-poppler.dylib \
      $(brew --prefix zathura)/lib/zathura/libpdf-poppler.dylib
  fi
}

configure_zathura() {
  if [[ "$BUILD_ONLY" -eq 1 ]]; then
    return 0
  fi

  # Zathura config
  rm -rf $HOMEDIR/.config/zathura
  ln -s $THISDIR/config/zathura $HOMEDIR/.config/zathura
}

