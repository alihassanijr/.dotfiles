#!/usr/bin/env bash
# gnu awk

AWK_VERSION="5.4.0"

install_gnu_awk() {
  echo "Installing dependency: gnu awk"
  
  local TMPDIR=$(build_tmpdir gnu_awk)
  local PACKAGEURLS=(
    "https://ftpmirror.gnu.org/gnu/gawk/gawk-$AWK_VERSION.tar.xz"
    "https://ftp.gnu.org/gnu/gawk/gawk-$AWK_VERSION.tar.xz"
  )
  local PACKAGETARNAME="gawk-$AWK_VERSION.tar.xz"
  local PACKAGEDIRNAME="gawk-$AWK_VERSION"
  
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
      --disable-silent-rules \
      --without-libsigsegv-prefix && \
    make -j$NUM_WORKERS install

  if [ $? -ne 0 ]; then
    echo "gnu awk build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi

  cd $THISDIR
  rm -rf $TMPDIR
}
