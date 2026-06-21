#!/usr/bin/env bash
# Git (because sometimes it's WAYYY tooo old)

GIT_VERSION="2.45.0"

install_git() {
  MAKECMND="$LOCALDIR/bin/make"
  if [[ ! -f "$LOCALDIR/bin/make" ]]; then
    echo "WARNING: you opted out of building make from source."
    echo "Building git from source is sensitive to make version."
    MAKECMND="make"
  fi

  local TMPDIR=$(build_tmpdir git)
  local PACKAGEURL="https://mirrors.edge.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.xz"
  local PACKAGETARNAME="git-$GIT_VERSION.tar.xz"
  local PACKAGEDIRNAME="git-$GIT_VERSION"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  cd $TMPDIR && \
    fetch_package $PACKAGETARNAME $PACKAGEURL && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./configure \
      --prefix=${LOCALDIR} && \
    make -j$NUM_WORKERS && \
    make install

  if [ $? -ne 0 ]; then
    echo "git build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi
  cd $THISDIR
  rm -rf $TMPDIR
}
