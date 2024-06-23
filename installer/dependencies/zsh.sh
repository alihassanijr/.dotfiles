#!/bin/bash
# ZShell

build_zsh() {
  local TMPDIR=$THISDIR/tmp_zsh
  local PACKAGEURL="https://downloads.sourceforge.net/project/zsh/zsh/5.9/zsh-5.9.tar.xz"
  local PACKAGETARNAME="zsh-5.9.tar.xz"
  local PACKAGEDIRNAME="zsh-5.9"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  cd $TMPDIR && \
    wget $PACKAGEURL -O $PACKAGETARNAME && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    PKG_CONFIG_PATH="$LOCALDIR/lib/pkgconfig:$PKG_CONFIG_PATH" ./configure \
      CFLAGS="-I$LOCALDIR/include -I$NCDIR/include -I$NCDIR/include/ncursesw" LDFLAGS="-L$LOCALDIR/lib -L$NCDIR/lib" \
       --enable-site-fndir=$LOCALDIR/share/zsh/site-functions \
       --enable-site-scriptdir=$LOCALDIR/share/zsh/site-scripts \
       --enable-cap \
       --enable-maildir-support \
       --enable-multibyte \
       --enable-pcre \
       --enable-zsh-secure-free \
       --enable-unicode9 \
       --enable-etcdir=/etc \
       --with-tcsetpgrp \
       DL_EXT=bundl \
      --prefix=${LOCALDIR} && \
    make install
  cd $THISDIR
  rm -rf $TMPDIR
}

install_zsh() {
  if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
    build_zsh
  else
    echo "ncurses not found! Zsh requires ncurses!"
    exit 1;
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
      ln -s $(which zsh) $LOCALDIR/bin/zsh
    fi

    ln -s $THISDIR/config/zsh $HOMEDIR/.config/zsh
}
