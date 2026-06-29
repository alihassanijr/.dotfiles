#!/usr/bin/env bash
# Alacritty
# Terminal emulator

install_alacritty() {
    echo "Can't install alacritty yet. Please install it manually."
    exit 1;
}

configure_alacritty() {
    # Alacritty config
    if [[ "$_OS_NAME" == "darwin" ]]; then
        link_directory "$THISDIR/config/alacritty.mac" "$HOMEDIR/.config/alacritty"
    else
        link_directory "$THISDIR/config/alacritty.linux" "$HOMEDIR/.config/alacritty"
    fi

    # No image / pdf viewing in Alacritty on mac yet!
}

