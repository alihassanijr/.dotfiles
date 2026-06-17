#!/bin/bash
# Make

install_make() {
  local TMPDIR=$THISDIR/tmp_make
  local PACKAGEURLS=(
    "https://ftpmirror.gnu.org/gnu/make/make-4.4.1.tar.gz"
    "https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz"
  )
  local PACKAGETARNAME="make-4.4.1.tar.gz"
  local PACKAGEDIRNAME="make-4.4.1"
  
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
