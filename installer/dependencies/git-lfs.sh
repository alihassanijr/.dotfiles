#!/bin/bash
# Git-lfs installer

GITLFSVER="3.3.0"

install_git_lfs() {
    local TMPDIR=$THISDIR/tmp
    local GITLFSURL=""
    local arch="$(uname -m)"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
        GITLFSURL="https://github.com/git-lfs/git-lfs/releases/download/v$GITLFSVER/git-lfs-darwin-amd64-v$GITLFSVER.zip"
    elif [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "arm64" ]]; then
        GITLFSURL="https://github.com/git-lfs/git-lfs/releases/download/v$GITLFSVER/git-lfs-darwin-arm64-v$GITLFSVER.zip"
    elif [[ "$OSTYPE" == "linux"* ]] && [[ "$arch" == "x86_64" ]]; then
        GITLFSURL="https://github.com/git-lfs/git-lfs/releases/download/v$GITLFSVER/git-lfs-linux-amd64-v$GITLFSVER.tar.gz"
    elif [[ "$OSTYPE" == "linux"* ]] && [[ "$arch" == "arm" ]]; then
        GITLFSURL="https://github.com/git-lfs/git-lfs/releases/download/v$GITLFSVER/git-lfs-linux-arm-v$GITLFSVER.tar.gz"
    elif [[ "$OSTYPE" == "linux"* ]] && [[ "$arch" == "arm64" ]]; then
        GITLFSURL="https://github.com/git-lfs/git-lfs/releases/download/v$GITLFSVER/git-lfs-linux-arm64-v$GITLFSVER.tar.gz"
    fi
    if [[ "$GITLFSURL" != "" ]]; then
        echo "Fetching static git-lfs binaries"
        if [[ $GITLFSURL == *"zip"* ]]; then
            cd $TMPDIR && \
                wget $GITLFSURL && \
                unzip git-lfs*.zip && \
                rm git-lfs*.zip && \
                mv git-lfs-*/git-lfs $LOCALDIR/bin/git-lfs && \
                cp -r -n -v git-lfs-*/man/* $LOCALDIR/man/
        else
            cd $TMPDIR && \
                wget $GITLFSURL && \
                tar -xzf git-lfs*.tar.gz && \
                rm git-lfs*.tar.gz && \
                mv git-lfs-*/git-lfs $LOCALDIR/bin/git-lfs && \
                cp -r -n -v git-lfs-*/man/* $LOCALDIR/man/
        fi
    else
        echo "Failed to install static git-lfs. Please install it manually before proceeding."
        echo "arch: $arch"
        echo "ostype: $OSTYPE"
        exit 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
