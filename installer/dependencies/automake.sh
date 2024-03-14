#!/bin/bash
# Automake

install_automake() {
    echo "Installing automake"

    local TMPDIR=$THISDIR/tmp_automake
    local PACKAGEURL="https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.xz"
    local PACKAGETARNAME="automake-1.16.5.tar.xz"
    local PACKAGEDIRNAME="automake-1.16.5"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        wget $PACKAGEURL -O $PACKAGETARNAME && \
        tar -xf $PACKAGETARNAME && \
        rm $PACKAGETARNAME && \
        cd $PACKAGEDIRNAME && \
        ./configure \
          --prefix=${LOCALDIR} && \
        make install

    cd $THISDIR
    rm -rf $TMPDIR
}
