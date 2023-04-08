#!/bin/bash
# Htop builder
# Sometimes not pre-installed, and I insist on having everything regardless
# of my sudo access. And let's face it, that's not always the only limit.

install_htop() {
    if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
        cd $THISDIR/third_party/htop/ && ./autogen.sh && \
            HTOP_NCURSES6_CONFIG_SCRIPT=$NCDIR/bin/ncursesw6-config \
            LDFLAGS="-L$NCDIR/lib" \
            CPPFLAGS="-I$NCDIR/include" \
            CFLAGS="-I$NCDIR/include" \
            ./configure --prefix=$LOCALDIR \
                    && make && make install
        cd $THISDIR
    else
        echo "ncurses not found! Vifm requires ncurses!"
        exit 1;
    fi
}

configure_htop() {
    # Htop config
    rm -rf $HOMEDIR/.config/htop
    ln -s $THISDIR/config/htop $HOMEDIR/.config/htop
}
