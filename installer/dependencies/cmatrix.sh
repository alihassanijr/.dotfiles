#!/bin/bash

install_cmatrix() {
    if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
        INSTALLARG="-DCMAKE_INSTALL_PREFIX=$LOCALDIR"
        NCARG="-DCURSES_INCLUDE_DIR=$NCDIR/include -DCURSES_LIB_DIR=$NCDIR/lib -DCURSES_LIBRARIES=-lncursesw"
        cd $THISDIR/third_party/misc/cmatrix/ && mkdir build && cd build && \
            cmake $INSTALLARG $NCARG .. && \
            make && make install && \
            cd .. && rm -rf build
        cd $THISDIR
    else
        echo "ncurses not found! cmatrix requires ncurses!"
        exit 1;
    fi
}

