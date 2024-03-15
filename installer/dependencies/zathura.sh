#!/bin/bash
# Zathura
# Document viewer

install_zathura() {
    echo "FAILED: Please install Zathura using homebrew."
}

configure_zathura() {
    # Zathura config
    rm -rf $HOMEDIR/.config/zathura
    ln -s $THISDIR/config/zathura $HOMEDIR/.config/zathura
}

