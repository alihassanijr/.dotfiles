#!/usr/bin/env bash
# Tre installer
# Just gives more options than tree

TRE_VERSION="0.4.0"

install_tre() {
    local TMPDIR=$(build_tmpdir tre)
    local TREURL=""
    local arch="$(uname -m)"

    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR
    mkdir -p $TMPDIR/tre

    if [[ "$_OS_NAME" == "darwin" ]] && [[ "$arch" == "arm64" ]]; then
        TREURL="https://github.com/dduan/tre/releases/download/v$TRE_VERSION/tre-v$TRE_VERSION-aarch64-apple-darwin.tar.gz"
    elif [[ "$_OS_NAME" == "darwin" ]] && [[ "$arch" == "x86_64" ]]; then
        TREURL="https://github.com/dduan/tre/releases/download/v$TRE_VERSION/tre-v$TRE_VERSION-x86_64-apple-darwin.tar.gz"
    elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "x86_64" ]]; then
        TREURL="https://github.com/dduan/tre/releases/download/v$TRE_VERSION/tre-v$TRE_VERSION-x86_64-unknown-linux-musl.tar.gz"
    elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "arm" ]]; then
        TREURL="https://github.com/dduan/tre/releases/download/v$TRE_VERSION/tre-v$TRE_VERSION-arm-unknown-linux-gnueabihf.tar.gz"
    elif [[ "$_OS_NAME" == "linux" ]] && [[ ( "$arch" == "arm64" || "$arch" == "aarch64" ) ]]; then
        # abandoned project without arm64 dist
        # arm one can technically run in some cases where 32-bit binaries can run, but I don't
        # want to take any chances.
        # building my own in a fork.
        TREURL="https://github.com/alihassanijr/tre/releases/download/v$TRE_VERSION/tre-v$TRE_VERSION-aarch64-unknown-linux-musl.tar.gz"
    fi
    if [[ "$TREURL" != "" ]]; then
        echo "Fetching static tre binaries"
        cd $TMPDIR && fetch_package "$(basename $TREURL)" $TREURL && tar -xzf tre*.tar.gz -C tre/ && rm tre*.tar.gz && mv tre/tre $LOCALDIR/bin/tre
        if [ $? -ne 0 ]; then
            echo "Failed to fetch/install tre."
            cd $THISDIR
            rm -rf $TMPDIR
            return 1
        fi
    else
        echo "Failed to install static tre. Please install it manually before proceeding."
        echo "arch: $arch"
        echo "os: $_OS_NAME"
        return 1
    fi
    cd $THISDIR
    rm -rf $TMPDIR
}
