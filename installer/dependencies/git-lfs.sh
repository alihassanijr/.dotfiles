#!/bin/bash
# Git-lfs installer

GITLFS_VERSION="3.7.0"

install_git_lfs() {
    local TMPDIR=$(build_tmpdir git_lfs)
    local GITLFSURL=""
    local arch="$(uname -m)"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    if [[ "$_OS_NAME" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
        GITLFSURL="https://github.com/git-lfs/git-lfs/releases/download/v$GITLFS_VERSION/git-lfs-darwin-amd64-v$GITLFS_VERSION.zip"
    elif [[ "$_OS_NAME" == "darwin"* ]] && [[ "$arch" == "arm64" ]]; then
        GITLFSURL="https://github.com/git-lfs/git-lfs/releases/download/v$GITLFS_VERSION/git-lfs-darwin-arm64-v$GITLFS_VERSION.zip"
    elif [[ "$_OS_NAME" == "linux"* ]] && [[ "$arch" == "x86_64" ]]; then
        GITLFSURL="https://github.com/git-lfs/git-lfs/releases/download/v$GITLFS_VERSION/git-lfs-linux-amd64-v$GITLFS_VERSION.tar.gz"
    elif [[ "$_OS_NAME" == "linux"* ]] && [[ "$arch" == "arm" ]]; then
        GITLFSURL="https://github.com/git-lfs/git-lfs/releases/download/v$GITLFS_VERSION/git-lfs-linux-arm-v$GITLFS_VERSION.tar.gz"
    elif [[ "$_OS_NAME" == "linux"* ]] && [[ ( "$arch" == "arm64" || "$arch" == "aarch64" ) ]]; then
        GITLFSURL="https://github.com/git-lfs/git-lfs/releases/download/v$GITLFS_VERSION/git-lfs-linux-arm64-v$GITLFS_VERSION.tar.gz"
    fi
    if [[ "$GITLFSURL" != "" ]]; then
        echo "Fetching static git-lfs binaries"
        if [[ $GITLFSURL == *"zip"* ]]; then
            cd $TMPDIR && \
                fetch_package "$(basename $GITLFSURL)" $GITLFSURL && \
                unzip git-lfs*.zip && \
                rm git-lfs*.zip && \
                mv git-lfs-*/git-lfs $LOCALDIR/bin/git-lfs && \
                cp -r -n -v git-lfs-*/man/* $LOCALDIR/man/
            if [ $? -ne 0 ]; then
                echo "Failed to fetch/install git-lfs."
                cd $THISDIR
                rm -rf $TMPDIR
                return 1
            fi
        else
            cd $TMPDIR && \
                fetch_package "$(basename $GITLFSURL)" $GITLFSURL && \
                tar -xzf git-lfs*.tar.gz && \
                rm git-lfs*.tar.gz && \
                mv git-lfs-*/git-lfs $LOCALDIR/bin/git-lfs && \
                cp -r -n -v git-lfs-*/man/* $LOCALDIR/man/
            if [ $? -ne 0 ]; then
                echo "Failed to fetch/install git-lfs."
                cd $THISDIR
                rm -rf $TMPDIR
                return 1
            fi
        fi
    else
        echo "Failed to install static git-lfs. Please install it manually before proceeding."
        echo "arch: $arch"
        echo "os: $_OS_NAME"
        return 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
