#!/bin/bash
# Alacritty
# Terminal emulator

install_alacritty() {
    echo "Can't install alacritty yet. Please install it manually."
    exit 1;
}

configure_alacritty() {
    # Alacritty config
    rm -rf $HOMEDIR/.config/alacritty
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ln -s $THISDIR/config/alacritty.mac $HOMEDIR/.config/alacritty
    fi

    # No image / pdf viewing in Alacritty on mac yet!
}

