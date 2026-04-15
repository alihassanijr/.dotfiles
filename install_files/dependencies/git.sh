#!/bin/bash
# Git (because sometimes it's WAYYY tooo old)

install_git() {
  MAKECMND="$LOCALDIR/bin/make"
  if [[ ! -f "$LOCALDIR/bin/make" ]]; then
    echo "WARNING: you opted out of building make from source."
    echo "Building git from source is sensitive to make version."
    MAKECMND="make"
  fi

  local TMPDIR=$THISDIR/tmp_git
  local PACKAGEURL="https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.45.0.tar.xz"
  local PACKAGETARNAME="git-2.45.0.tar.xz"
  local PACKAGEDIRNAME="git-2.45.0"
  
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
