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
    
      if [[ "$_OS_NAME" == "darwin" ]] && [[ "$arch" == "x86_64" ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-aarch64-apple-darwin.tar.gz"
      elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "x86_64" ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-x86_64-unknown-linux-gnu.tar.gz"
      elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "i686" ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-i686-unknown-linux-gnu.tar.gz"
      elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "arm" ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-arm-unknown-linux-gnueabihf.tar.gz"
      elif [[ "$_OS_NAME" == "linux" ]] && [[ ( "$arch" == "arm64" || "$arch" == "aarch64" ) ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-aarch64-unknown-linux-gnu.tar.gz"
      fi
      if [[ "$BATURL" != "" ]]; then
          echo "Fetching static bat binaries"
          cd $TMPDIR && fetch_package "$(basename $BATURL)" $BATURL && tar -xzf bat*.tar.gz && rm bat*.tar.gz && mv bat*/bat $LOCALDIR/bin/bat
          if [ $? -ne 0 ]; then
              echo "Failed to fetch/install bat."
              cd $THISDIR
              rm -rf $TMPDIR
              return 1
          fi
      else
          echo "Failed to install static bat. Please install it manually before proceeding."
          echo "arch: $arch"
          echo "os: $_OS_NAME"
          return 1
      fi

    cd $THISDIR
    rm -rf $TMPDIR
}

configure_bat() {
    # Bat config
    rm -rf $HOMEDIR/.config/bat
    ln -s $THISDIR/config/bat $HOMEDIR/.config/bat
}
