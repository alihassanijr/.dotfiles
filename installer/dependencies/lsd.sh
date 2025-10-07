#!/bin/bash
# RIP EXA -- LSD installer
# Why ls when you can LSD?

LSDVER="v1.1.5"

install_lsd() {
    local TMPDIR=$THISDIR/tmp
    local LSDURL=""
    local arch="$(uname -m)"

    if [[ -f "$(which exa)" ]]; then
      # Found EXA -- delete it and replace it with LSD.
      PATHTOEXA=$(which $DEP_NAME)
      echo "EXA is deprecated, and was found at $PATHTOEXA. I suggest you get rid of it."
      read -p "Delete exa? [y/n]: " -n 1 -r
      echo ""
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
          echo "Removing exa..."
          rm -f $PATHTOEXA
          rm -f $LOCALDIR/bin/exa
          rm -f $LOCALDIR/man/*exa*
      fi
    fi

    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "arm64" ]]; then
        LSDURL="https://github.com/lsd-rs/lsd/releases/download/$LSDVER/lsd-$LSDVER-aarch64-apple-darwin.tar.gz"
    elif [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
        LSDURL="https://github.com/lsd-rs/lsd/releases/download/$LSDVER/lsd-$LSDVER-x86_64-apple-darwin.tar.gz"
    elif [[ "$OSTYPE" == "linux"* ]] && [[ "$arch" == "x86_64" ]]; then
        LSDURL="https://github.com/lsd-rs/lsd/releases/download/$LSDVER/lsd-$LSDVER-x86_64-unknown-linux-gnu.tar.gz"
    elif [[ "$OSTYPE" == "linux"* ]] && [[ "$arch" == "arm" ]]; then
        LSDURL="https://github.com/lsd-rs/lsd/releases/download/$LSDVER/lsd-$LSDVER-arm-unknown-linux-gnueabihf.tar.gz"
    elif [[ "$OSTYPE" == "linux"* ]] && [[ ( "$arch" == "arm64" || "$arch" == "aarch64" ) ]]; then
        LSDURL="https://github.com/lsd-rs/lsd/releases/download/$LSDVER/lsd-$LSDVER-aarch64-unknown-linux-gnu.tar.gz"
    fi
    if [[ "$LSDURL" != "" ]]; then
        echo "Fetching static LSD binaries"
        cd $TMPDIR && \
            wget $LSDURL && \
            tar -xzf lsd*.tar.gz && \
            rm lsd*.tar.gz && \
            mv lsd*/lsd $LOCALDIR/bin/lsd && \
            mv lsd*/lsd.1 $LOCALDIR/man/man1/
    else
        echo "Failed to install static LSD. Please install it manually before proceeding."
        echo "arch: $arch"
        echo "ostype: $OSTYPE"
        exit 1
    fi
    cd $THISDIR
    rm -rf $TMPDIR
}
