#!/usr/bin/env bash

PROCPS_VERSION="4.0.4"

install_watch() {
  echo "Installing procps/watch"

  local TMPDIR=$(build_tmpdir watch)
  local PACKAGEURLS=(
    "https://downloads.sourceforge.net/project/procps-ng/Production/procps-ng-$PROCPS_VERSION.tar.xz"
    "https://newcontinuum.dl.sourceforge.net/project/procps-ng/Production/procps-ng-$PROCPS_VERSION.tar.xz"
  )
  local PACKAGETARNAME="procps-ng-$PROCPS_VERSION.tar.xz"
  local PACKAGEDIRNAME="procps-ng-$PROCPS_VERSION"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR

  cd $TMPDIR && \
      fetch_package $PACKAGETARNAME "${PACKAGEURLS[@]}" && \
      tar -xf $PACKAGETARNAME && \
      rm $PACKAGETARNAME && \
      cd $PACKAGEDIRNAME && \
      ./configure \
        --prefix=$TMPDIR/build/ \
        --disable-dependency-tracking \
        --disable-nls \
        --enable-watch8bit \
        --with-ncurses \
        --verbose \
        CFLAGS="-I$NCDIR/include/" \
        CPPFLAGS="-I$NCDIR/include/" && \
      make -j$NUM_WORKERS src/watch &&
      mv src/watch ${LOCALDIR}/bin/ && \
      mkdir -p ${LOCALDIR}/man/man1/ && \
      mv man/watch.1 ${LOCALDIR}/man/man1/

  if [ $? -ne 0 ]; then
    echo "procps/watch build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi

  cd $THISDIR
  rm -rf $TMPDIR
}
