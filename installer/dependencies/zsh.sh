#!/bin/bash
# ZShell
# Not yet building this from source, but
# I obviously have my own config

install_zsh() {
    echo "Error: I can't build zsh from source yet. Quitting..."
    exit 1
}

configure_zsh() {
    # ZSHrc and logout
    echo "Linking zshrc to ~/.zshrc"
    rm $HOMEDIR/.zshrc
    ln -s $THISDIR/zshrc $HOMEDIR/.zshrc
    echo "Linking zlogout to ~/.zlogout"
    rm $HOMEDIR/.zlogout
    ln -s $THISDIR/zlogout $HOMEDIR/.zlogout
}
