#!/usr/bin/env bash
# gnu grep

GREP_VERSION="3.12"

install_gnu_grep() {
  echo "Installing dependency: gnu grep"
  
  local TMPDIR=$(build_tmpdir gnu_grep)
  local PACKAGEURLS=(
    "https://ftpmirror.gnu.org/gnu/grep/grep-$GREP_VERSION.tar.xz"
    "https://ftp.gnu.org/gnu/grep/grep-$GREP_VERSION.tar.xz"
  )
  local PACKAGETARNAME="grep-$GREP_VERSION.tar.xz"
  local PACKAGEDIRNAME="grep-$GREP_VERSION"
  
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
      --disable-nls && \
    make -j$NUM_WORKERS install

  if [ $? -ne 0 ]; then
    echo "gnu grep build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi

  cd $THISDIR
  rm -rf $TMPDIR
}
