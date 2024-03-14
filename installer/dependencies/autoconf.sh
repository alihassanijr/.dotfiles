#!/bin/bash
# Autoconf

install_autoconf() {
    echo "Installing autoconf"

    check_hard_dependency "m4"

    local TMPDIR=$THISDIR/tmp_autoconf
    local PACKAGEURL="https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz"
    local PACKAGETARNAME="https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz"
    local PACKAGEDIRNAME="autoconf-2.72"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        wget $PACKAGEURL -O $PACKAGETARNAME && \
        tar -xzf $PACKAGETARNAME && \
        rm $PACKAGETARNAME && \
        cd $PACKAGEDIRNAME && \
        ./configure \
          --prefix=${LOCALDIR} && \
        make install

    cd $THISDIR
    rm -rf $TMPDIR
}
