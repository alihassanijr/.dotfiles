#!/bin/bash

install_gettext() {
  echo "Installing gettext"

  local TMPDIR=$(build_tmpdir gettext)
  local PACKAGEURLS=(
    "https://ftpmirror.gnu.org/gnu/gettext/gettext-0.22.5.tar.gz"
    "https://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.gz"
  )
  local PACKAGETARNAME="gettext-0.22.5.tar.gz"
  local PACKAGEDIRNAME="gettext-0.22.5"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR

  cd $TMPDIR && \
      fetch_package $PACKAGETARNAME "${PACKAGEURLS[@]}" && \
      tar -xzf $PACKAGETARNAME && \
      rm $PACKAGETARNAME && \
      cd $PACKAGEDIRNAME && \
      ./configure \
        --prefix=${LOCALDIR} \
        --disable-silent-rules \
        --with-included-glib \
        --with-included-libcroco \
        --with-included-libunistring \
        --with-included-libxml \
        --with-included-gettext \
        --disable-java \
        --disable-csharp \
        --without-git \
        --without-cvs \
        --without-xz && \
      make -j$NUM_WORKERS && \
      make install

  if [ $? -ne 0 ]; then
    echo "gettext build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi

  cd $THISDIR
  rm -rf $TMPDIR
}
