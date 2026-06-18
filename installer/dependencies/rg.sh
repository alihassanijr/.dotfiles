#!/bin/bash
# Ripgrep (rg) installer
# RIP, grep!

RGVER="14.1.1"

install_rg() {
    local TMPDIR=$(build_tmpdir rg)
    local RGURL=""
    local arch="$(uname -m)"

    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    if [[ "$_OS_NAME" == "darwin" ]] && [[ "$arch" == "arm64" ]]; then
        RGURL="https://github.com/BurntSushi/ripgrep/releases/download/$RGVER/ripgrep-$RGVER-aarch64-apple-darwin.tar.gz"
    elif [[ "$_OS_NAME" == "darwin" ]] && [[ "$arch" == "x86_64" ]]; then
        RGURL="https://github.com/BurntSushi/ripgrep/releases/download/$RGVER/ripgrep-$RGVER-x86_64-apple-darwin.tar.gz"
    elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "x86_64" ]]; then
        RGURL="https://github.com/BurntSushi/ripgrep/releases/download/$RGVER/ripgrep-$RGVER-x86_64-unknown-linux-musl.tar.gz"
    elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "arm" ]]; then
        RGURL="https://github.com/BurntSushi/ripgrep/releases/download/$RGVER/ripgrep-$RGVER-arm-unknown-linux-gnueabihf.tar.gz"
    elif [[ "$_OS_NAME" == "linux" ]] && [[ ( "$arch" == "arm64" || "$arch" == "aarch64" ) ]]; then
        RGURL="https://github.com/BurntSushi/ripgrep/releases/download/$RGVER/ripgrep-$RGVER-aarch64-unknown-linux-gnu.tar.gz"
    fi
    if [[ "$RGURL" != "" ]]; then
        echo "Fetching static ripgrep"
        cd $TMPDIR && fetch_package "$(basename $RGURL)" $RGURL && tar -xzf ripgrep*.tar.gz && rm ripgrep*.tar.gz && mv ripgrep*/rg $LOCALDIR/bin/rg
        if [ $? -ne 0 ]; then
            echo "Failed to fetch/install ripgrep."
            cd $THISDIR
            rm -rf $TMPDIR
            return 1
        fi
    else
        echo "Failed to install static ripgrep. Please install it manually before proceeding."
        echo "arch: $arch"
        echo "os: $_OS_NAME"
        return 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
