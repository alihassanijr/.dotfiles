#!/bin/bash
# Tmux

install_libevent() {

  # Dependency: libtool
  source installer/dependencies/libtool.sh
  check_and_install_dependency "libtool" "$LOCALDIR/bin/libtool" "install_libtool" || {
    echo "Libevent dependency resolution failed. Won't attempt build.";
    return 1
  }
  # check_and_install_hard_dependency "libtool" "install_libtool"

  echo "Installing dependency: libevent"
  
  local TMPDIR=$THISDIR/tmp_libevent
  local PACKAGEURL="https://github.com/libevent/libevent/archive/refs/tags/release-2.1.12-stable.tar.gz"
  local PACKAGETARNAME="libevent-release-2.1.12-stable.tar.gz"
  local PACKAGEDIRNAME="libevent-release-2.1.12-stable"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  cd $TMPDIR && \
    fetch_package $PACKAGETARNAME $PACKAGEURL && \
    tar -xzf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./autogen.sh && \
    ./configure \
      --prefix=${LOCALDIR} \
      --disable-dependency-tracking \
      --disable-debug-mode && \
    make -j$NUM_WORKERS && \
    make install

  if [ $? -ne 0 ]; then
    echo "Libevent build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi
  
  cd $THISDIR
  rm -rf $TMPDIR
}

install_utf8proc() {
  echo "Installing dependency: utf8proc"
  
  local TMPDIR=$THISDIR/tmp_utf8proc
  local PACKAGEURL="https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.9.0.tar.gz"
  local PACKAGETARNAME="utf8proc.tar.gz"
  local PACKAGEDIRNAME="utf8proc-2.9.0/"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  cd $TMPDIR && \
    fetch_package $PACKAGETARNAME $PACKAGEURL && \
    tar -xzf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    make -j$NUM_WORKERS install prefix=${LOCALDIR}

  if [ $? -ne 0 ]; then
    echo "Utf8proc build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi

  cd $THISDIR
  rm -rf $TMPDIR
}

install_tmux_dependencies() {
  if [[ -f "$LOCALDIR/include/event.h" ]]; then
    echo "Libevent is already installed, skipping..."
  else
    install_libevent || { echo "FAILED TO BUILD TMUX DEPENDENCY: libevent!"; return 1; }
  fi
  if [[ -f "$LOCALDIR/include/utf8proc.h" ]]; then
    echo "utf8proc is already installed, skipping..."
  else
    install_utf8proc || { echo "FAILED TO BUILD TMUX DEPENDENCY: ut8proc!"; return 1; }
  fi
}

build_tmux() {
  local TMPDIR=$THISDIR/tmp_tmux
  local PACKAGEURL="https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz"
  local PACKAGETARNAME="tmux-3.4.tar.gz"
  local PACKAGEDIRNAME="tmux-3.4/"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR

  if [[ "$_OS_NAME" == "darwin" ]]; then
    ADDITIONAL_TMUX_CONF_ARGS="-with-TERM=screen-256color"
  fi
  
  cd $TMPDIR && \
    fetch_package $PACKAGETARNAME $PACKAGEURL && \
    tar -xzf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./configure \
      --enable-sixel \
      --enable-utf8proc \
      $ADDITIONAL_TMUX_CONF_ARGS \
      --prefix=${LOCALDIR} && \
    make -j$NUM_WORKERS install

  if [ $? -ne 0 ]; then
    echo "Tmux build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi

  cd $THISDIR
  rm -rf $TMPDIR
}

install_tmux() {
  if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
    install_tmux_dependencies || { echo "FAILED TO BUILD TMUX DEPENDENCIES!"; return 1; }
    build_tmux || { echo "FAILED TO BUILD TMUX!"; return 1; }
  else
    echo "ncurses not found! Tmux requires ncurses!"
    return 1
  fi
}

configure_tmux() {
  # Tmux config files
  if program_exists tmux; then
    rm $HOMEDIR/.tmux.conf
    if [[ "$_OS_NAME" == "darwin" ]]; then
      ln -s $THISDIR/tmux.mac.conf $HOMEDIR/.tmux.conf
    else
      ln -s $THISDIR/tmux.conf $HOMEDIR/.tmux.conf
    fi
    
    mkdir -p $HOMEDIR/.config/
    rm -rf $HOMEDIR/.config/tmux
    ln -s $THISDIR/config/tmux $HOMEDIR/.config/tmux
  fi
}
