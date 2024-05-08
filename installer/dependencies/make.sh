#!/bin/bash
# Make

install_make() {
  local TMPDIR=$THISDIR/tmp_make
  local PACKAGEURL="https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz"
  local PACKAGETARNAME="make-4.4.1.tar.gz"
  local PACKAGEDIRNAME="make-4.4.1"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  cd $TMPDIR && \
    wget $PACKAGEURL -O $PACKAGETARNAME && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./configure \
      --prefix=${LOCALDIR} && \
    make && \
    make install
  cd $THISDIR
  rm -rf $TMPDIR
}
