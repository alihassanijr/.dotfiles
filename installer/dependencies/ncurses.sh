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
        make && make install
    cd $THISDIR
    rm -rf $TMPDIR
}
