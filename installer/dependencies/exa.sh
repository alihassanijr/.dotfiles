#!/bin/bash
# Exa installer
# Why ls when you can exa?

EXAVER="0.10.1"

install_exa() {
    local TMPDIR=$THISDIR/tmp
    local EXAURL=""
    local arch="$(uname -m)"

    if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "arm64" ]]; then
        brew install exa
    else
        cd $THISDIR
        rm -rf $TMPDIR
        mkdir -p $TMPDIR

        if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
            EXAURL="https://github.com/ogham/exa/releases/download/v$EXAVER/exa-macos-x86_64-v$EXAVER.zip"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "x86_64" ]]; then
            EXAURL="https://github.com/ogham/exa/releases/download/v$EXAVER/exa-linux-x86_64-v$EXAVER.zip"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "arm" ]]; then
            EXAURL="https://github.com/ogham/exa/releases/download/v$EXAVER/exa-linux-armv7-v$EXAVER.zip"
        fi
        if [[ "$EXAURL" != "" ]]; then
            echo "Fetching static exa binaries"
            cd $TMPDIR && \
                wget $EXAURL && \
                unzip exa*.zip -d exa/ && \
                rm exa*.zip && \
                mv exa/bin/exa $LOCALDIR/bin/exa && \
                cp -r -n -v exa/man/* $LOCALDIR/man/
        else
            echo "Failed to install static exa. Please install it manually before proceeding."
            echo "arch: $arch"
            echo "ostype: $OSTYPE"
            exit 1
        fi
        cd $THISDIR
        rm -rf $TMPDIR
    fi
}
