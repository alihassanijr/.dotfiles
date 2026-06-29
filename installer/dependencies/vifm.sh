#!/usr/bin/env bash
# Vifm builder
# It's rarely pre-installed, and I insist on having everything regardless
# of my sudo access. And let's face it, that's not always the only limit.

VIFM_VERSION="0.14.4"

install_vifm() {
    if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
        local TMPDIR=$(build_tmpdir vifm)
        local PACKAGEURL="https://github.com/vifm/vifm/releases/download/v$VIFM_VERSION/vifm-$VIFM_VERSION.tar.bz2"
        local PACKAGETARNAME="vifm-$VIFM_VERSION.tar.bz2"
        local PACKAGEDIRNAME="vifm-$VIFM_VERSION"
        local NCARG="--with-curses=$NCDIR --with-curses-name=ncursesw"

        cd $THISDIR
        rm -rf $TMPDIR
        mkdir -p $TMPDIR

        cd $TMPDIR && \
            fetch_package $PACKAGETARNAME $PACKAGEURL && \
            tar -xjf $PACKAGETARNAME && \
            rm $PACKAGETARNAME && \
            cd $PACKAGEDIRNAME && \
            ./configure --prefix=$LOCALDIR $NCARG && \
            make -j$NUM_WORKERS VERBOSE=1 && \
            make install

        if [ $? -ne 0 ]; then
            echo "vifm build failed."
            cd $THISDIR
            rm -rf $TMPDIR
            return 1
        fi

        cd $THISDIR
        rm -rf $TMPDIR
    else
        echo "ncurses not found! Vifm requires ncurses!"
        return 1
    fi
}

configure_vifm() {
    # Replace the vifm files
    echo "Linking vifm files..."
    if [[ "$_OS_NAME" == "darwin" ]]; then
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
    link_file "$VIFMRC" "$HOMEDIR/.vifm/vifmrc"
    VIFMFILES=("graphics" "scripts" "colors" "shell-completion" "plugins" "vim" "man" "vimfiles"
               "vifm.desktop" "vifm-help.txt" "vifm.appdata.xml")
    for vifmfile in ${VIFMFILES[*]};do
        echo "Linking $vifmfile";
        # VIFMFILES is a mix of directories and plain files.
        if [[ -d $THISDIR/vifm/$vifmfile ]]; then
            link_directory "$THISDIR/vifm/$vifmfile" "$HOMEDIR/.vifm/$vifmfile"
        else
            link_file "$THISDIR/vifm/$vifmfile" "$HOMEDIR/.vifm/$vifmfile"
        fi
    done;
}
