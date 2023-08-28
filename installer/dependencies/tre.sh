#!/bin/bash
# Tre installer
# Just gives more options than tree

TREVER="0.4.0"

install_tre() {
    local TMPDIR=$THISDIR/tmp
    local TREURL=""
    local arch="$(uname -m)"

    if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "arm64" ]]; then
        brew install tre-command
    else
        cd $THISDIR
        rm -rf $TMPDIR
        mkdir -p $TMPDIR
        mkdir -p $TMPDIR/tre

        if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
            TREURL="https://github.com/dduan/tre/releases/download/v$TREVER/tre-v$TREVER-x86_64-apple-darwin.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "x86_64" ]]; then
            TREURL="https://github.com/dduan/tre/releases/download/v$TREVER/tre-v$TREVER-x86_64-unknown-linux-musl.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "arm" ]]; then
            TREURL="https://github.com/dduan/tre/releases/download/v$TREVER/tre-v$TREVER-arm-unknown-linux-gnueabihf.tar.gz"
        fi
        if [[ "$TREURL" != "" ]]; then
            echo "Fetching static tre binaries"
            cd $TMPDIR && wget $TREURL && tar -xzf tre*.tar.gz -C tre/ && rm tre*.tar.gz && mv tre/tre $LOCALDIR/bin/tre
        else
            echo "Failed to install static tre. Please install it manually before proceeding."
            echo "arch: $arch"
            echo "ostype: $OSTYPE"
            exit 1
        fi
        cd $THISDIR
        rm -rf $TMPDIR
    fi
}
