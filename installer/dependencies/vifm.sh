#!/bin/bash
# Vifm builder
# It's rarely pre-installed, and I insist on having everything regardless
# of my sudo access. And let's face it, that's not always the only limit.

install_vifm() {
    if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
        NCARG="--with-curses=$NCDIR --with-curses-name=ncursesw"
        cd $THISDIR/third_party/vifm/ && \
          autoreconf -f -i && \
          ./configure --prefix=$LOCALDIR $NCARG && \
          make -j$NUM_WORKERS VERBOSE=1 && \
          make install
        cd $THISDIR
    else
        echo "ncurses not found! Vifm requires ncurses!"
        exit 1;
    fi
}

configure_vifm() {
    # Replace the vifm files
    echo "Linking vifm files..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        VIFMRC=$THISDIR/vifmrc.mac
    else
        VIFMRC=$THISDIR/vifmrc
    fi
    # Don't go removing my vifm
    # rm -rf $HOMEDIR/.vifm
    if ! [[ -d $HOMEDIR/.vifm ]]; then
        # cp -r $THISDIR/vifm $HOMEDIR/.vifm
        mkdir -p $HOMEDIR/.vifm
    fi
    rm -rf $HOMEDIR/.vifm/vifmrc
    ln -s $VIFMRC $HOMEDIR/.vifm/vifmrc
    VIFMFILES=("graphics" "scripts" "colors" "shell-completion" "plugins" "vim" "man" "vimfiles"
               "vifm.desktop" "vifm-help.txt" "vifm.appdata.xml")
    for vifmfile in ${VIFMFILES[*]};do
        echo "Linking $vifmfile";
        rm -rf $HOMEDIR/.vifm/$vifmfile
        ln -s $THISDIR/vifm/$vifmfile $HOMEDIR/.vifm/$vifmfile
    done;
}
