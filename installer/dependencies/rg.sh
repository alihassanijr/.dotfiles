#!/bin/bash
# Ripgrep (rg) installer
# RIP, grep!

RGVER="13.0.0"

install_rg() {
    local TMPDIR=$THISDIR/tmp
    local RGURL=""
    local arch="$(uname -m)"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
        RGURL="https://github.com/BurntSushi/ripgrep/releases/download/$RGVER/ripgrep-$RGVER-x86_64-apple-darwin.tar.gz"
    elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "x86_64" ]]; then
        RGURL="https://github.com/BurntSushi/ripgrep/releases/download/$RGVER/ripgrep-$RGVER-x86_64-unknown-linux-musl.tar.gz"
    elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "arm" ]]; then
        RGURL="https://github.com/BurntSushi/ripgrep/releases/download/$RGVER/ripgrep-$RGVER-arm-unknown-linux-gnueabihf.tar.gz"
    fi
    if [[ "$RGURL" != "" ]]; then
        echo "Fetching static ripgrep"
        cd $TMPDIR && wget $RGURL && tar -xzf ripgrep*.tar.gz && rm ripgrep*.tar.gz && mv ripgrep*/rg $LOCALDIR/bin/rg
    else
        echo "Failed to install static ripgrep. Please install it manually before proceeding."
        echo "arch: $arch"
        echo "ostype: $OSTYPE"
        exit 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
