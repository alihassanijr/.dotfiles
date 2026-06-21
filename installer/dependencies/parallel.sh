#!/usr/bin/env bash
# gnu parallel

PARALLEL_VERSION="20260522"

install_parallel() {
  local TMPDIR=$(build_tmpdir parallel)
  local PACKAGEURLS=(
    "https://ftpmirror.gnu.org/gnu/parallel/parallel-$PARALLEL_VERSION.tar.bz2"
    "https://ftp.gnu.org/gnu/parallel/parallel-$PARALLEL_VERSION.tar.bz2"
  )
  local PACKAGETARNAME="parallel-$PARALLEL_VERSION.tar.bz2"
  local PACKAGEDIRNAME="parallel-$PARALLEL_VERSION"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  cd $TMPDIR && \
    fetch_package $PACKAGETARNAME "${PACKAGEURLS[@]}" && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./configure \
      --prefix=${LOCALDIR} && \
    make -j$NUM_WORKERS install

  if [ $? -ne 0 ]; then
    echo "parallel build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi
  cd $THISDIR
  rm -rf $TMPDIR
}
