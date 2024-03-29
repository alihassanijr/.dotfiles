#!/bin/bash
# wget

# TODO: this may be unnecessary -- make it conditional in the future
build_openssl() {
    echo "Installing dependency: OpenSSL"

    local TMPDIR=$THISDIR/tmp_openssl
    local PACKAGEURL="https://www.openssl.org/source/openssl-3.0.13.tar.gz"
    local PACKAGETARNAME="openssl-3.0.13.tar.gz"
    local PACKAGEDIRNAME="openssl-3.0.13"

    local OPENSSLTARGET=""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OPENSSLTARGET="darwin64-$(uname -m)-cc"
    else
        echo "WARNING: please read this in detail!!"
        echo "If you're reading this, it means you're trying to build wget on a device\"
        that is not running MacOS. This is highly unanticipated, because it realistically\"
        only leaves out Linux, and most distros have wget. If you still want to proceed,\"
        you will need to install OpenSSL, which is a dependency, but not to worry, I have you\"
        covered. You just need to find your CPU architecture and whether or not it's 64-bit."

        echo "Once you have that ready, enter it below (I was too lazy to figure out how to query uname and get it myself; sorry)."

        INPUT_TARGET=""
        SHOW_CHOICES=1

        while [ $SHOW_CHOICES -gt 0 ]; do

            echo "Choices:"
            echo "(intel - 32-bit)  linux-elf"
            echo "(intel - 64-bit)  linux-x86_64"
            echo "(arm - 32-bit)  linux-armv4"
            echo "(arm - 64-bit)  linux-aarch64"

            read INPUT_TARGET

            if [[ $INPUT_TARGET == "linux-x86_64" ]] || \
               [[ $INPUT_TARGET == "linux-elf" ]] || \
               [[ $INPUT_TARGET == "linux-aarch64" ]] || \
               [[ $INPUT_TARGET == "linux-armv4" ]]; then
                SHOW_CHOICES=0
            fi
        done
    fi
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        curl -o $PACKAGETARNAME $PACKAGEURL && \
        tar -xzf $PACKAGETARNAME && \
        rm $PACKAGETARNAME && \
        cd $PACKAGEDIRNAME && \
        ./Configure \
            --prefix=${LOCALDIR} \
            --openssldir=./ssl \
            $OPENSSLTARGET && \
        make install

    cd $THISDIR
    rm -rf $TMPDIR
}

install_wget_dependencies() {
    build_openssl
}

build_wget() {
    local TMPDIR=$THISDIR/tmp_wget
    local PACKAGEURL="https://ftp.gnu.org/gnu/wget/wget-1.24.5.tar.gz"
    local PACKAGETARNAME="wget-1.24.5.tar.gz"
    local PACKAGEDIRNAME="wget-1.24.5/"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        curl -o $PACKAGETARNAME $PACKAGEURL && \
        tar -xzf $PACKAGETARNAME && \
        rm $PACKAGETARNAME && \
        cd $PACKAGEDIRNAME && \
        ./configure \
            --prefix=${LOCALDIR} \
            --disable-pcre --disable-pcre2 \
            --with-ssl=openssl \
            --without-included-regex \
            --without-libpsl \
            --with-libssl-prefix=${LOCALDIR} && \
        make &&
        make install
    cd $THISDIR
    rm -rf $TMPDIR
}

install_wget() {
    check_hard_dependency "curl"
    install_wget_dependencies
    build_wget
}

configure_wget() {
    echo "ca_certificate=/etc/ssl/cert.pem" >> $HOMEDIR/.wgetrc
}
