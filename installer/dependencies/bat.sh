#!/bin/bash
# Bat installer
# Bats are better than cats ;)

BATVER="0.25.0"

install_bat() {
    local TMPDIR=$THISDIR/tmp
    local BATURL=""
    local arch="$(uname -m)"

    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR
    
      if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-aarch64-apple-darwin.tar.gz"
      elif [[ "$OSTYPE" == "linux"* ]] && [[ "$arch" == "x86_64" ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-x86_64-unknown-linux-gnu.tar.gz"
      elif [[ "$OSTYPE" == "linux"* ]] && [[ "$arch" == "i686" ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-i686-unknown-linux-gnu.tar.gz"
      elif [[ "$OSTYPE" == "linux"* ]] && [[ "$arch" == "arm" ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-arm-unknown-linux-gnueabihf.tar.gz"
      elif [[ "$OSTYPE" == "linux"* ]] && [[ ( "$arch" == "arm64" || "$arch" == "aarch64" ) ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-aarch64-unknown-linux-gnu.tar.gz"
      fi
      if [[ "$BATURL" != "" ]]; then
          echo "Fetching static bat binaries"
          cd $TMPDIR && wget $BATURL && tar -xzf bat*.tar.gz && rm bat*.tar.gz && mv bat*/bat $LOCALDIR/bin/bat
      else
          echo "Failed to install static bat. Please install it manually before proceeding."
          echo "arch: $arch"
          echo "ostype: $OSTYPE"
          exit 1
      fi

    cd $THISDIR
    rm -rf $TMPDIR
}

configure_bat() {
    # Bat config
    rm -rf $HOMEDIR/.config/bat
    ln -s $THISDIR/config/bat $HOMEDIR/.config/bat
}
