#!/bin/bash
# Aria2 builder
# File downloader

install_gettext() {
    echo "Installing dependency: gettext"

    local TMPDIR=$THISDIR/tmp_gettext
    local PACKAGEURL="https://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.gz"
    local PACKAGETARNAME="gettext-0.22.5.tar.gz"
    local PACKAGEDIRNAME="gettext-0.22.5"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        wget $PACKAGEURL -O $PACKAGETARNAME && \
        tar -xzf $PACKAGETARNAME && \
        rm $PACKAGETARNAME && \
        cd $PACKAGEDIRNAME && \
        ./configure \
          --prefix=${LOCALDIR} \
          --disable-silent-rules \
          --with-included-glib \
          --with-included-libcroco \
          --with-included-libunistring \
          --with-included-libxml \
          --with-included-gettext \
          --disable-java \
          --disable-csharp \
          --without-git \
          --without-cvs \
          --without-xz && \
        make && \
        make install

    cd $THISDIR
    rm -rf $TMPDIR
}

install_aria2_dependencies() {
    check_and_install_hard_dependency "gettext" "install_gettext"
}

install_aria2() {
    install_aria2_dependencies

    # Build
    cd $THISDIR/third_party/aria2/ && \
        autoreconf -i && \
        ./configure ARIA2_STATIC=yes && \
        make && \
        make check
    # Move to .local/bin
    mv $THISDIR/third_party/aria2/src/aria2c $LOCALDIR/bin/aria2c
    # Cleanup
    cd $THISDIR/third_party/aria2/ && \
        git stash && \
        git stash drop

    cd $THISDIR
}
