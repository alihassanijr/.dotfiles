#!/bin/bash
# gnu coreutils

install_coreutils() {
  echo "Installing dependency: coreutils"
  
  local TMPDIR=$(build_tmpdir coreutils)
  local PACKAGEURLS=(
    "https://ftpmirror.gnu.org/gnu/coreutils/coreutils-9.5.tar.xz"
    "https://ftp.gnu.org/gnu/coreutils/coreutils-9.5.tar.xz"
  )
  local PACKAGETARNAME="coreutils-9.5.tar.xz"
  local PACKAGEDIRNAME="coreutils-9.5"
  
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
