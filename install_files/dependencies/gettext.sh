#!/bin/bash

install_gettext() {
  echo "Installing gettext"

  local TMPDIR=$THISDIR/tmp_gettext
  local PACKAGEURL="https://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.gz"
  local PACKAGETARNAME="gettext-0.22.5.tar.gz"
  local PACKAGEDIRNAME="gettext-0.22.5"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR

  cd $TMPDIR && \
      wget $PACKAGEURL -O $PACKAGETARNAME && \
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
      make && \
      make install

  cd $THISDIR
  rm -rf $TMPDIR
}
