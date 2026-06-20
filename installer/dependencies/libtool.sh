#!/bin/bash
# libtool: shared dependency between tmux and aria2

LIBTOOL_VERSION="2.4.7"

install_libtool() {
  echo "Installing dependency: libtool"
  
  local TMPDIR=$(build_tmpdir libtool)
  local PACKAGEURLS=(
    "https://ftpmirror.gnu.org/gnu/libtool/libtool-$LIBTOOL_VERSION.tar.xz"
    "https://ftp.gnu.org/gnu/libtool/libtool-$LIBTOOL_VERSION.tar.xz"
  )
  local PACKAGETARNAME="libtool-$LIBTOOL_VERSION.tar.xz"
  local PACKAGEDIRNAME="libtool-$LIBTOOL_VERSION"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  cd $TMPDIR && \
    fetch_package $PACKAGETARNAME "${PACKAGEURLS[@]}" && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./configure \
      --prefix=${LOCALDIR} \
      --disable-dependency-tracking \
      --enable-ltdl-install && \
    make -j$NUM_WORKERS install

  if [ $? -ne 0 ]; then
    echo "Libtool build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi
  
  cd $THISDIR
  rm -rf $TMPDIR
}
