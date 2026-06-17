#!/bin/bash
# Autoconf

install_autoconf() {
    check_hard_dependency "m4"

    local TMPDIR=$THISDIR/tmp_autoconf
    local PACKAGEURLS=(
        "https://ftpmirror.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz"
        "https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz"
    )
    local PACKAGETARNAME="autoconf-2.72.tar.gz"
    local PACKAGEDIRNAME="autoconf-2.72"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        fetch_package $PACKAGETARNAME "${PACKAGEURLS[@]}" && \
        tar -xzf $PACKAGETARNAME && \
        rm $PACKAGETARNAME && \
        cd $PACKAGEDIRNAME && \
        ./configure \
          --prefix=${LOCALDIR} && \
        make -j$NUM_WORKERS install

    if [ $? -ne 0 ]; then
      echo "autoconf build failed."
      cd $THISDIR
      rm -rf $TMPDIR
      return 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
