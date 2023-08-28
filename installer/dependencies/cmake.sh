#!/bin/bash
# CMake installer
# Fetches the expected build and dumps it
# I am tired of the old cmakes and having to use conda whenever I need cutlass.

CMAKEVER="3.25.3"

install_cmake() {
    local TMPDIR=$THISDIR/tmp
    local CMAKEURL=""
    local CMAKEDIR="cmake*/"
    local arch="$(uname -m)"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    if [[ "$OSTYPE" == "darwin"* ]]; then
        CMAKEURL="https://github.com/Kitware/CMake/releases/download/v$CMAKEVER/cmake-$CMAKEVER-macos-universal.tar.gz"
        CMAKEDIR="cmake*/CMake.app/Contents/"
    elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "x86_64" ]]; then
        CMAKEURL="https://github.com/Kitware/CMake/releases/download/v$CMAKEVER/cmake-$CMAKEVER-linux-x86_64.tar.gz"
    elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "aarch64" ]]; then
        CMAKEURL="https://github.com/Kitware/CMake/releases/download/v$CMAKEVER/cmake-$CMAKEVER-linux-aarch64.tar.gz"
    fi
    if [[ "$CMAKEURL" != "" ]]; then
        echo "Fetching static cmake binaries"
        cd $TMPDIR && wget $CMAKEURL && tar -xzf cmake*.tar.gz && rm cmake*.tar.gz && \
            mv $CMAKEDIR/bin/* $LOCALDIR/bin/ && \
            cp -r -n -v $CMAKEDIR/share/* $LOCALDIR/share/
    else
        echo "Failed to install static cmake. Please install it manually before proceeding."
        echo "arch: $arch"
        echo "ostype: $OSTYPE"
        exit 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
