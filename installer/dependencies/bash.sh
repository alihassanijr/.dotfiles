#!/usr/bin/env bash
# bash
# yeah, I make my own bash too... because BSD stands of Big Sack of D... Disappointment
# "oh you want to run your scripts on your mac? why don't you run docker first..." no more!!!

BASH_VERSION="5.3"

build_bash() {
  local TMPDIR=$(build_tmpdir bash)
  local PACKAGEURLS=(
    "https://ftpmirror.gnu.org/gnu/bash/bash-$BASH_VERSION.tar.gz"
    "https://ftp.gnu.org/gnu/bash/bash-$BASH_VERSION.tar.gz"
    "https://mirrors.kernel.org/gnu/bash/bash-$BASH_VERSION.tar.gz"
    "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-$BASH_VERSION.tar.gz"
  )
  local PACKAGETARNAME="bash-$BASH_VERSION.tar.gz"
  local PACKAGEDIRNAME="bash-$BASH_VERSION"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  # NOTE: in some os-es, bash builder ignores curses lib paths in LD_LIBRARY_PATH
  cd $TMPDIR && \
    fetch_package $PACKAGETARNAME "${PACKAGEURLS[@]}" && \
    tar -xzf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    CFLAGS="-L$NCDIR/lib $CFLAGS" \
    CPPFLAGS="-L$NCDIR/lib $CPPFLAGS" \
    ./configure \
       --with-curses \
       --with-installed-readline \
      --prefix=${LOCALDIR} && \
    make -j$NUM_WORKERS install

  if [ $? -ne 0 ]; then
    echo "bash build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi
  cd $THISDIR
  rm -rf $TMPDIR
}

install_bash() {
  if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
    build_bash
  else
    echo "ncurses not found! bash requires ncurses!"
    return 1
  fi
}
