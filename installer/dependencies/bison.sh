#!/usr/bin/env bash
# bison: tmux build dependency

BISON_VERSION="3.8.2"

install_bison() {
  echo "Installing dependency: bison"

  local TMPDIR=$(build_tmpdir bison)
  local PACKAGEURLS=(
    "https://ftpmirror.gnu.org/gnu/bison/bison-$BISON_VERSION.tar.xz"
    "https://ftp.gnu.org/gnu/bison/bison-$BISON_VERSION.tar.xz"
  )
  local PACKAGETARNAME="bison-$BISON_VERSION.tar.xz"
  local PACKAGEDIRNAME="bison-$BISON_VERSION"

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
      --enable-relocatable \
      M4=m4 && \
    make install

  if [ $? -ne 0 ]; then
    echo "Bison build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi

  cd $THISDIR
  rm -rf $TMPDIR
}
