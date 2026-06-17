#!/bin/bash
# Automake

install_automake() {
    echo "Installing automake"

    local TMPDIR=$THISDIR/tmp_automake
    local PACKAGEURLS=(
        "https://ftpmirror.gnu.org/gnu/automake/automake-1.16.5.tar.xz"
        "https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.xz"
    )
    local PACKAGETARNAME="automake-1.16.5.tar.xz"
    local PACKAGEDIRNAME="automake-1.16.5"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        fetch_package $PACKAGETARNAME "${PACKAGEURLS[@]}" && \
        tar -xf $PACKAGETARNAME && \
        rm $PACKAGETARNAME && \
        cd $PACKAGEDIRNAME && \
        ./configure \
          --prefix=${LOCALDIR} && \
        make -j$NUM_WORKERS install

    if [ $? -ne 0 ]; then
      echo "automake build failed."
      cd $THISDIR
      rm -rf $TMPDIR
      return 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
