#!/bin/bash
# NCurses builder
# Vim, Vifm, and htop require curses or ncurses

NCURSESVER="6.4"

install_ncurses() {
    local TMPDIR=$THISDIR/tmp
    local NCURSESURL="http://ftp.gnu.org/pub/gnu/ncurses/ncurses-$NCURSESVER.tar.gz"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        wget $NCURSESURL && \
        tar -xzf ncurses*.tar.gz && \
        rm ncurses*.tar.gz && \
        cd ncurses-$NCURSESVER && \
        ./configure \
            --enable-widec --with-shared \
            --prefix=$NCDIR \
            CFLAGS="-I$NCDIR/include" \
            LIBS="-L$NCDIR/lib" && \
        make -j$NUM_WORKERS VERBOSE=1 && \
        make install

    if [[ "$OSTYPE" != "darwin"* ]]; then
      # libtinfo is provided by ncurses and has the same api.
      # Some linux builds fail if they don't resolve libtinfo.so.5
      # https://bugs.centos.org/view.php?id=11423
      # https://bugs.launchpad.net/ubuntu/+source/ncurses/+bug/259139
      # https://github.com/Homebrew/homebrew-core/blob/de082970c864349afb94745a771698c429d89fbf/Formula/n/ncurses.rb#L71C7-L74C70
      ln -s $NCDIR/lib/libncursesw.so $NCDIR/lib/libtinfo.so
      ln -s $NCDIR/lib/libtinfo.so $NCDIR/lib/libtinfo.so.5
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
