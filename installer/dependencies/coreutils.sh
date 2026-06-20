#!/bin/bash
# gnu coreutils

COREUTILS_VERSION="9.5"

install_coreutils() {
  echo "Installing dependency: coreutils"
  
  local TMPDIR=$(build_tmpdir coreutils)
  local PACKAGEURLS=(
    "https://ftpmirror.gnu.org/gnu/coreutils/coreutils-$COREUTILS_VERSION.tar.xz"
    "https://ftp.gnu.org/gnu/coreutils/coreutils-$COREUTILS_VERSION.tar.xz"
  )
  local PACKAGETARNAME="coreutils-$COREUTILS_VERSION.tar.xz"
  local PACKAGEDIRNAME="coreutils-$COREUTILS_VERSION"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  if [[ -d "$LOCALDIR/lib/perl5/" ]]; then
    export PERL5LIB=$LOCALDIR/lib/perl5/
  fi
  cd $TMPDIR && \
    fetch_package $PACKAGETARNAME "${PACKAGEURLS[@]}" && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./configure \
      --prefix=${LOCALDIR}/extras/coreutils && \
    make -j$NUM_WORKERS && \
    make install

  if [ $? -ne 0 ]; then
    echo "coreutils build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi

  cd $THISDIR
  rm -rf $TMPDIR
}
