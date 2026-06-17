#!/bin/bash
# M4

install_m4() {
    echo "Installing m4"

    local TMPDIR=$THISDIR/tmp_m4
    local PACKAGEURLS=(
        "https://ftpmirror.gnu.org/gnu/m4/m4-1.4.19.tar.xz"
        "https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz"
    )
    local PACKAGETARNAME="m4-1.4.19.tar.xz"
    local PACKAGEDIRNAME="m4-1.4.19"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        fetch_package $PACKAGETARNAME "${PACKAGEURLS[@]}" && \
        tar -xf $PACKAGETARNAME && \
        rm $PACKAGETARNAME && \
        cd $PACKAGEDIRNAME && \
        ./configure \
          --prefix=${LOCALDIR} \
          --disable-dependency-tracking && \
        make -j$NUM_WORKERS && \
        make install

    if [ $? -ne 0 ]; then
        echo "m4 build failed."
        cd $THISDIR
        rm -rf $TMPDIR
        return 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
