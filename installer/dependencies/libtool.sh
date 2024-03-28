#!/bin/bash
# libtool: shared dependency between tmux and aria2

install_libtool() {
  echo "Installing dependency: libtool"
  
  local TMPDIR=$THISDIR/tmp_libtool
  local PACKAGEURL="https://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.xz"
  local PACKAGETARNAME="libtool-2.4.7.tar.xz"
  local PACKAGEDIRNAME="libtool-2.4.7"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  cd $TMPDIR && \
    wget $PACKAGEURL -O $PACKAGETARNAME && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./configure \
      --prefix=${LOCALDIR} \
      --disable-dependency-tracking \
      --enable-ltdl-install && \
    make install
  
  cd $THISDIR
  rm -rf $TMPDIR
}
