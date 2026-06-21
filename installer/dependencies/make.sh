#!/usr/bin/env bash
# Make

MAKE_VERSION="4.4.1"

install_make() {
  local TMPDIR=$(build_tmpdir make)
  local PACKAGEURLS=(
    "https://ftpmirror.gnu.org/gnu/make/make-$MAKE_VERSION.tar.gz"
    "https://ftp.gnu.org/gnu/make/make-$MAKE_VERSION.tar.gz"
  )
  local PACKAGETARNAME="make-$MAKE_VERSION.tar.gz"
  local PACKAGEDIRNAME="make-$MAKE_VERSION"
  
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
      --disable-dependency-tracking && \
    ./build.sh && \
    ./make -j$NUM_WORKERS install

  if [ $? -ne 0 ]; then
    echo "make build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi
  cd $THISDIR
  rm -rf $TMPDIR
}
