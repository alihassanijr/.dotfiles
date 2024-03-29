#!/bin/bash
# gnu coreutils

install_coreutils() {
  echo "Installing dependency: coreutils"
  
  local TMPDIR=$THISDIR/tmp_coreutils
  local PACKAGEURL="https://ftp.gnu.org/gnu/coreutils/coreutils-9.5.tar.xz"
  local PACKAGETARNAME="coreutils-9.5.tar.xz"
  local PACKAGEDIRNAME="coreutils-9.5"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  cd $TMPDIR && \
    wget $PACKAGEURL -O $PACKAGETARNAME && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./configure \
      --prefix=${LOCALDIR}/extras/coreutils && \
    make && \
    make install
  
  cd $THISDIR
  rm -rf $TMPDIR
}
