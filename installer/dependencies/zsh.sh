#!/usr/bin/env bash
# ZShell

ZSH_PKG_VERSION="5.9.1"
# 5.9 hangs on mac, 5.9.1 doesn't... due to divine malevolence as far as I can gather
# for a second I thought pcre/pcre2 might have been the issue, but it turns out it wasn't.
# bringing pcre2 in anyway to avoid any weirdness moving forward
PCRE2_VERSION="10.47"

install_pcre2() {

  # Dependency: libtool
  source installer/dependencies/libtool.sh
  check_and_install_dependency "libtool" "$LOCALDIR/bin/libtool" "install_libtool" || {
    echo "pcre2 dependency resolution failed. Won't attempt build.";
    return 1
  }

  echo "Installing dependency: pcre2"
  
  local TMPDIR=$(build_tmpdir pcre2)
  local PACKAGEURL="https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE2_VERSION/pcre2-$PCRE2_VERSION.tar.bz2"
  local PACKAGETARNAME="pcre2-$PCRE2_VERSION.tar.bz2"
  local PACKAGEDIRNAME="pcre2-$PCRE2_VERSION"

  if [[ "$_OS_NAME" == "darwin" ]]; then
    local ADDITIONAL_PCRE2_CONF_ARGS="--enable-pcre2test-libedit"
  fi
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  cd $TMPDIR && \
    fetch_package $PACKAGETARNAME $PACKAGEURL && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./configure \
      --prefix=${LOCALDIR} \
      --disable-dependency-tracking \
      --enable-pcre2-16 \
      --enable-pcre2-32 \
      --enable-pcre2grep-libz \
      --enable-pcre2grep-libbz2 \
      --enable-jit \
      $ADDITIONAL_PCRE2_CONF_ARGS && \
    make -j$NUM_WORKERS && \
    make install

  if [ $? -ne 0 ]; then
    echo "pcre2 build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi
  
  cd $THISDIR
  rm -rf $TMPDIR
}

build_zsh() {
  # Dependency: pcre2
  check_and_install_dependency "pcre2" "$LOCALDIR/bin/pcre2" "install_pcre2" || {
    echo "pcre2 dependency resolution failed. Won't attempt build.";
    return 1
  }

  local TMPDIR=$(build_tmpdir zsh)
  local PACKAGEURL="https://downloads.sourceforge.net/project/zsh/zsh/$ZSH_PKG_VERSION/zsh-$ZSH_PKG_VERSION.tar.xz"
  local PACKAGETARNAME="zsh-$ZSH_PKG_VERSION.tar.xz"
  local PACKAGEDIRNAME="zsh-$ZSH_PKG_VERSION"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  cd $TMPDIR && \
    fetch_package $PACKAGETARNAME $PACKAGEURL && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./configure \
       --enable-site-fndir=$LOCALDIR/share/zsh/site-functions \
       --enable-site-scriptdir=$LOCALDIR/share/zsh/site-scripts \
       --enable-fndir=$LOCALDIR/share/zsh/functions \
       --enable-scriptdir=$LOCALDIR/share/zsh/scripts \
       --enable-runhelpdir=$LOCALDIR/share/zsh/help \
       --enable-cap \
       --enable-maildir-support \
       --enable-multibyte \
       --enable-pcre \
       --enable-zsh-secure-free \
       --enable-unicode9 \
       --enable-etcdir=/etc \
       --with-tcsetpgrp \
       DL_EXT=bundle \
      --prefix=${LOCALDIR} && \
    make -j$NUM_WORKERS install

  if [ $? -ne 0 ]; then
    echo "zsh build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi
  cd $THISDIR
  rm -rf $TMPDIR
}

install_zsh() {
  if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
    build_zsh
  else
    echo "ncurses not found! Zsh requires ncurses!"
    return 1
  fi
}

configure_zsh() {
    # ZSHrc and logout
    echo "Linking zshrc to ~/.zshrc"
    rm $HOMEDIR/.zshrc
    ln -s $THISDIR/zshrc $HOMEDIR/.zshrc
    echo "Linking zlogout to ~/.zlogout"
    rm $HOMEDIR/.zlogout
    ln -s $THISDIR/zlogout $HOMEDIR/.zlogout

    # So that tmux wouldn't have to look for ZSH
    if [[ ! -f $LOCALDIR/bin/zsh ]]; then
      echo "Linking zsh binary (because you opted out of building it)."
      ln -s $(program_path zsh) $LOCALDIR/bin/zsh
    fi

    mkdir -p $HOMEDIR/.config/
    rm -rf $HOMEDIR/.config/zsh
    ln -s $THISDIR/config/zsh $HOMEDIR/.config/zsh
}
