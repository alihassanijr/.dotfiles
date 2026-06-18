#!/bin/bash
# Htop builder
# Sometimes not pre-installed, and I insist on having everything regardless
# of my sudo access. And let's face it, that's not always the only limit.

install_htop() {
    if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
        local TMPDIR=$(build_tmpdir htop)
        local PACKAGEURL="https://github.com/htop-dev/htop/archive/refs/tags/3.5.1.tar.gz"
        local PACKAGETARNAME="htop-3.5.1.tar.gz"
        local PACKAGEDIRNAME="htop-3.5.1"

        cd $THISDIR
        rm -rf $TMPDIR
        mkdir -p $TMPDIR

        cd $TMPDIR && \
            fetch_package $PACKAGETARNAME $PACKAGEURL && \
            tar -xzf $PACKAGETARNAME && \
            rm $PACKAGETARNAME && \
            cd $PACKAGEDIRNAME && \
            ./autogen.sh && \
            HTOP_NCURSES6_CONFIG_SCRIPT=$NCDIR/bin/ncursesw6-config \
            LDFLAGS="-L$NCDIR/lib" \
            CPPFLAGS="-I$NCDIR/include" \
            CFLAGS="-I$NCDIR/include" \
            ./configure --prefix=$LOCALDIR && \
            make -j$NUM_WORKERS VERBOSE=1 && \
            make install

        if [ $? -ne 0 ]; then
            echo "htop build failed."
            cd $THISDIR
            rm -rf $TMPDIR
            return 1
        fi

        cd $THISDIR
        rm -rf $TMPDIR
    else
        echo "ncurses not found! htop requires ncurses!"
        return 1
    fi
}

configure_htop() {
    # Htop config
    rm -rf $HOMEDIR/.config/htop
    ln -s $THISDIR/config/htop $HOMEDIR/.config/htop
}
