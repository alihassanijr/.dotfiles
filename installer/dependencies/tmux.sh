#!/bin/bash
# Tmux
# Not yet building this from source, but
# I obviously have my own config

install_tmux() {
    echo "Error: I can't build tmux from source yet. Quitting..."
    exit 1
}

configure_tmux() {
    # Tmux config files
    if [[ -f "$(which tmux)" ]]; then
        rm $HOMEDIR/.tmux.conf
        ln -s $THISDIR/tmux.conf $HOMEDIR/.tmux.conf

        mkdir -p $HOMEDIR/.config/
        rm -rf $HOMEDIR/.config/tmux
        ln -s $THISDIR/config/tmux $HOMEDIR/.config/tmux
    fi
}
