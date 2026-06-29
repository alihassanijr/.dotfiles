#!/usr/bin/env bash
# Bat installer
# Bats are better than cats ;)

BAT_VERSION="0.26.1"

install_bat() {
    local TMPDIR=$(build_tmpdir bat)
    local BATURL=""
    local arch="$(uname -m)"

    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR
    
      if [[ "$_OS_NAME" == "darwin" ]] && [[ "$arch" == "x86_64" ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-x86_64-apple-darwin.tar.gz"
      elif [[ "$_OS_NAME" == "darwin" ]] && [[ ( "$arch" == "arm64" || "$arch" == "aarch64" ) ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-aarch64-apple-darwin.tar.gz"
      elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "x86_64" ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-x86_64-unknown-linux-gnu.tar.gz"
      elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "i686" ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-i686-unknown-linux-gnu.tar.gz"
      elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "arm" ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-arm-unknown-linux-gnueabihf.tar.gz"
      elif [[ "$_OS_NAME" == "linux" ]] && [[ ( "$arch" == "arm64" || "$arch" == "aarch64" ) ]]; then
          BATURL="https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-aarch64-unknown-linux-gnu.tar.gz"
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
    link_directory "$THISDIR/config/bat" "$HOMEDIR/.config/bat"
}
