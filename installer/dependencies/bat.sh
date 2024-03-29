#!/bin/bash
# Bat installer
# Bats are better than cats ;)

BATVER="0.22.1"

install_bat() {
    local TMPDIR=$THISDIR/tmp
    local BATURL=""
    local arch="$(uname -m)"

    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR
    
    if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "arm64" ]]; then
        echo "Unfortunately, bat doesn't build binaries for Apple Silicon Macs, which is what you have."
        echo "The alternative is simple enough; it just requires docker (since I don't want to install rust)."
        echo "And I didn't want to assume docker's already set up."
        echo ""
        echo "To build your own, refer to: https://github.com/alihassanijr/shoddy/blob/main/bat-from-source-for-apple-silicon"
        echo ""
        echo "You could also download mine, but careful, it might not work."
        read -p "Download bat binary from alihassanijr's github? [y/n]: " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            echo "Downloading bat from alihassanijr/shoddy"
            BATURL="https://github.com/alihassanijr/shoddy/raw/main/bat-from-source-for-apple-silicon/build/bin/bat"
            cd $TMPDIR && \
                wget $BATURL -O bat_aarch64_apple_darwin && \
                mv bat_aarch64_apple_darwin $LOCALDIR/bin/bat && \
                chmod +x $LOCALDIR/bin/bat
        fi
    else
        if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
            BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-x86_64-apple-darwin.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "x86_64" ]]; then
            BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-x86_64-unknown-linux-gnu.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "i686" ]]; then
            BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-i686-unknown-linux-gnu.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "arm" ]]; then
            BATURL="https://github.com/sharkdp/bat/releases/download/v$BATVER/bat-v$BATVER-arm-unknown-linux-gnueabihf.tar.gz"
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
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}

configure_bat() {
    # Bat config
    rm -rf $HOMEDIR/.config/bat
    ln -s $THISDIR/config/bat $HOMEDIR/.config/bat
}
