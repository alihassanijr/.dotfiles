#!/bin/bash
# M4

install_m4() {
    echo "Installing m4"

    local TMPDIR=$THISDIR/tmp_m4
    local PACKAGEURL="https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz"
    local PACKAGETARNAME="m4-1.4.19.tar.xz"
    local PACKAGEDIRNAME="m4-1.4.19"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        wget $PACKAGEURL -O $PACKAGETARNAME && \
        tar -xf $PACKAGETARNAME && \
        rm $PACKAGETARNAME && \
        cd $PACKAGEDIRNAME && \
        ./configure \
          --prefix=${LOCALDIR} \
          --disable-dependency-tracking && \
        make && \
        make install

    cd $THISDIR
    rm -rf $TMPDIR
}
