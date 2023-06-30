#!/bin/bash
# Kitty
# Terminal emulator

install_kitty() {
    local TMPDIR=$THISDIR/tmp
    local KITTYURL="https://sw.kovidgoyal.net/kitty/installer.sh"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        wget $KITTYURL && \
        bash installer.sh

    cd $THISDIR
    rm -rf $TMPDIR
}

configure_kitty() {
    # Kitty config
    rm -rf $HOMEDIR/.config/kitty
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ln -s $THISDIR/config/kitty.mac $HOMEDIR/.config/kitty
    fi

    # Kitty PDF Viewer!
    # Set up to work with VimTeX + Kitty on mac
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! [[ -f "$(which termpdf)" ]]; then
            read -p "Install TermPDF? (requires python3 and kitty) [y/n]: " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]
            then
                echo "Setting up termpdf"
                cd $THISDIR/third_party/misc/termpdf/ && pip3 install -r requirements.txt
                rm -rf $LOCALDIR/bin/termpdf
                ln -s $THISDIR/third_party/misc/termpdf/termpdf.py $LOCALDIR/bin/termpdf
            fi
        fi
        if ! [[ -f "$(which dcat)" ]]; then
            read -p "Install Document Cat (dcat)? (requires python3 and kitty) [y/n]: " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]
            then
                echo "Setting up dcat"
                pip3 install PyMuPDF
                rm -rf $LOCALDIR/bin/dcat
                ln -s $THISDIR/scripts/dcat $LOCALDIR/bin/dcat
            fi
        fi
    fi
}

