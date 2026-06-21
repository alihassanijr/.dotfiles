#!/usr/bin/env bash
# Automake

AUTOMAKE_VERSION="1.16.5"

install_automake() {
    echo "Installing automake"

    local TMPDIR=$(build_tmpdir automake)
    local PACKAGEURLS=(
        "https://ftpmirror.gnu.org/gnu/automake/automake-$AUTOMAKE_VERSION.tar.xz"
        "https://ftp.gnu.org/gnu/automake/automake-$AUTOMAKE_VERSION.tar.xz"
    )
    local PACKAGETARNAME="automake-$AUTOMAKE_VERSION.tar.xz"
    local PACKAGEDIRNAME="automake-$AUTOMAKE_VERSION"
    
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
