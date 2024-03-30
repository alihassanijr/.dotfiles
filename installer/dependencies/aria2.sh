#!/bin/bash
# Aria2 builder
# File downloader

install_aria2_dependencies() {
  # Dependency: libtool
  source installer/dependencies/libtool.sh
  check_and_install_dependency "libtool" "$LOCALDIR/bin/libtool" "install_libtool"
  # check_and_install_hard_dependency "libtool" "install_libtool"
}

install_aria2() {
  install_aria2_dependencies

  echo "Installing aria2"

  local TMPDIR=$THISDIR/tmp_aria2
  local PACKAGEURL="https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0.tar.xz"
  local PACKAGETARNAME="aria2-1.37.0.tar.xz"
  local PACKAGEDIRNAME="aria2-1.37.0"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR


  if [[ "$OSTYPE" == "darwin"* ]]; then
    EXTRA_CONFIG_ARGS="--with-appletls --without-openssl"
  else
    EXTRA_CONFIG_ARGS="--without-appletls --with-openssl"
  fi

  cd $TMPDIR && \
      wget $PACKAGEURL -O $PACKAGETARNAME && \
      tar -xf $PACKAGETARNAME && \
      rm $PACKAGETARNAME && \
      cd $PACKAGEDIRNAME && \
      ./configure \
        --prefix=${LOCALDIR} \
        --disable-dependency-tracking \
        --without-gnutls \
        --without-libgmp \
        --without-libnettle \
        --without-libgcrypt \
        $EXTRA_CONFIG_ARGS && \
      make install
      # --with-libssh2 \ # TODO: build libssh2, depends on openssl.

  cd $THISDIR
  rm -rf $TMPDIR
}
