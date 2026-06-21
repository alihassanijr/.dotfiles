#!/usr/bin/env bash
# pkg-config

PKG_CONFIG_VERSION="0.29.2"

install_pkg_config() {
    echo "Installing pkg-config"

    local TMPDIR=$(build_tmpdir pkg-config)
    local PACKAGEURL="https://pkgconfig.freedesktop.org/releases/pkg-config-$PKG_CONFIG_VERSION.tar.gz"
    local PACKAGETARNAME="pkg-config-$PKG_CONFIG_VERSION.tar.gz"
    local PACKAGEDIRNAME="pkg-config-$PKG_CONFIG_VERSION"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        curl -o $PACKAGETARNAME $PACKAGEURL && \
        tar -xzf $PACKAGETARNAME && \
        rm $PACKAGETARNAME

    if [[ "$_OS_NAME" == "darwin" ]]; then
        cd $TMPDIR && \
            cd $PACKAGEDIRNAME && \
            CFLAGS="-Wno-int-conversion" ./configure \
              --with-internal-glib \
              --disable-host-tool  \
              --disable-debug \
              --prefix=${LOCALDIR} && \
            CFLAGS="-Wno-int-conversion" make -j$NUM_WORKERS && \
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
            make -j$NUM_WORKERS && \
            make install
    fi

    if [ $? -ne 0 ]; then
        echo "pkg-config build failed."
        cd $THISDIR
        rm -rf $TMPDIR
        return 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
