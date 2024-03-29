#!/bin/bash
# Zathura
# Document viewer

install_homebrew() {
    echo "Cloning homebrew"
    git clone https://github.com/Homebrew/brew $HOME/.brew
}

install_zathura() {
    echo "I can only install Zathura via homebrew."
    echo "If you don't have homebrew, I'll install it locally and without root!"
    echo "Do you want to proceed?"
    read -p "Install Zathura via homebrew () [y/n]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      check_and_install_dependency "brew" "$HOMEDIR/.brew/bin/brew" "install_homebrew"

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
    # Zathura config
    rm -rf $HOMEDIR/.config/zathura
    ln -s $THISDIR/config/zathura $HOMEDIR/.config/zathura
}

