#!/bin/bash
# pkg-config

install_pkg_config() {
    echo "Installing pkg-config"

    local TMPDIR=$THISDIR/tmp_pkg-config
    local PACKAGEURL="https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz"
    local PACKAGETARNAME="pkg-config-0.29.2.tar.gz"
    local PACKAGEDIRNAME="pkg-config-0.29.2"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        wget $PACKAGEURL -O $PACKAGETARNAME && \
        tar -xzf $PACKAGETARNAME && \
        rm $PACKAGETARNAME

    if [[ "$OSTYPE" == "darwin"* ]]; then
        cd $TMPDIR && \
            cd $PACKAGEDIRNAME && \
            CFLAGS="-Wno-int-conversion" ./configure \
              --with-internal-glib \
              --disable-host-tool  \
              --disable-debug \
              --prefix=${LOCALDIR} && \
            CFLAGS="-Wno-int-conversion" make && \
            CFLAGS="-Wno-int-conversion" make install
    else
        # TODO: this is untested; I've only needed to install
        # pkg-config on mac.
        cd $TMPDIR && \
            cd $PACKAGEDIRNAME && \
            ./configure \
              --with-internal-glib \
              --disable-host-tool  \
              --disable-debug \
              --prefix=${LOCALDIR} && \
            make && \
            make install
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
