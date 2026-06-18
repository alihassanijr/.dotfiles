#!/bin/bash
# RIP EXA -- LSD installer
# Why ls when you can LSD?

LSDVER="v1.1.5"

install_lsd() {
    local TMPDIR=$(build_tmpdir lsd)
    local LSDURL=""
    local arch="$(uname -m)"

    if program_exists exa; then
      if [[ "$BUILD_ONLY" -eq 1 ]]; then
        echo "exa found during BUILD_ONLY; it should not exist in a containerized build."
        return 1
      fi
      # Found EXA -- delete it and replace it with LSD.
      PATHTOEXA=$(program_path $DEP_NAME)
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

    if [[ "$_OS_NAME" == "darwin" ]] && [[ "$arch" == "arm64" ]]; then
        LSDURL="https://github.com/lsd-rs/lsd/releases/download/$LSDVER/lsd-$LSDVER-aarch64-apple-darwin.tar.gz"
    elif [[ "$_OS_NAME" == "darwin" ]] && [[ "$arch" == "x86_64" ]]; then
        LSDURL="https://github.com/lsd-rs/lsd/releases/download/$LSDVER/lsd-$LSDVER-x86_64-apple-darwin.tar.gz"
    elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "x86_64" ]]; then
        LSDURL="https://github.com/lsd-rs/lsd/releases/download/$LSDVER/lsd-$LSDVER-x86_64-unknown-linux-gnu.tar.gz"
    elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "arm" ]]; then
        LSDURL="https://github.com/lsd-rs/lsd/releases/download/$LSDVER/lsd-$LSDVER-arm-unknown-linux-gnueabihf.tar.gz"
    elif [[ "$_OS_NAME" == "linux" ]] && [[ ( "$arch" == "arm64" || "$arch" == "aarch64" ) ]]; then
        LSDURL="https://github.com/lsd-rs/lsd/releases/download/$LSDVER/lsd-$LSDVER-aarch64-unknown-linux-gnu.tar.gz"
    fi
    if [[ "$LSDURL" != "" ]]; then
        echo "Fetching static LSD binaries"
        cd $TMPDIR && \
            fetch_package "$(basename $LSDURL)" $LSDURL && \
            tar -xzf lsd*.tar.gz && \
            rm lsd*.tar.gz && \
            mv lsd*/lsd $LOCALDIR/bin/lsd && \
            mv lsd*/lsd.1 $LOCALDIR/man/man1/
        if [ $? -ne 0 ]; then
            echo "Failed to fetch/install LSD."
            cd $THISDIR
            rm -rf $TMPDIR
            return 1
        fi
    else
        echo "Failed to install static LSD. Please install it manually before proceeding."
        echo "arch: $arch"
        echo "os: $_OS_NAME"
        return 1
    fi
    cd $THISDIR
    rm -rf $TMPDIR
}
