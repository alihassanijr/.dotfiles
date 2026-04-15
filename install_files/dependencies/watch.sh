#!/bin/bash

install_watch() {
  echo "Installing procps/watch"

  local TMPDIR=$THISDIR/tmp_watch
  local PACKAGEURL="https://newcontinuum.dl.sourceforge.net/project/procps-ng/Production/procps-ng-4.0.4.tar.xz"
  local PACKAGETARNAME="procps-ng-4.0.4.tar.xz"
  local PACKAGEDIRNAME="procps-ng-4.0.4"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR

  cd $TMPDIR && \
      wget $PACKAGEURL -O $PACKAGETARNAME && \
      tar -xf $PACKAGETARNAME && \
      rm $PACKAGETARNAME && \
      cd $PACKAGEDIRNAME && \
      ./configure \
        --prefix=$TMPDIR/build/ \
        --disable-dependency-tracking \
        --disable-nls \
        --enable-watch8bit \
        --with-ncurses \
        CFLAGS="-I$NCDIR/include/" && \
      make src/watch &&
      mv src/watch ${LOCALDIR}/bin/ &&
      mv man/watch.1 ${LOCALDIR}/man/man1

  cd $THISDIR
  rm -rf $TMPDIR
}
