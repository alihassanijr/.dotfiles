#!/bin/bash
# Vim builder
# Building vim from source because I want the same version of vim
# everywhere, and I want to decide when to upgrade or not.
# Even now most Ubuntu builds don't have vim9.

VIM_VERSION="9.2.0650"

install_vim() {
    # Couple of notes:
    # A. I disable selinux because not all the servers I'm on have it installed
    #    so I'm not going to bother.
    # B. To get my local ncurses (really ncursesw) to be recognized, I added
    #    its path to LDFLAGS and CFLAGS.
    # C. Needed to explicitly use --disable-darwin to have it build normally on
    #    mac.
    # D. Obviously installing to ~/.local/bin -- sourced in commonrc.
    if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
        local TMPDIR=$(build_tmpdir vim)
        local PACKAGEURL="https://github.com/vim/vim/archive/refs/tags/v$VIM_VERSION.tar.gz"
        local PACKAGETARNAME="vim-$VIM_VERSION.tar.gz"
        local PACKAGEDIRNAME="vim-$VIM_VERSION"

        cd $THISDIR
        rm -rf $TMPDIR
        mkdir -p $TMPDIR

        cd $TMPDIR && \
            fetch_package $PACKAGETARNAME $PACKAGEURL && \
            tar -xzf $PACKAGETARNAME && \
            rm $PACKAGETARNAME && \
            cd $PACKAGEDIRNAME && \
            LDFLAGS=-L${NCDIR}/lib                    \
            CFLAGS=-I${NCDIR}/include                 \
            ./configure                               \
            --with-features=huge                      \
            --enable-terminal                         \
            --enable-multibyte                        \
            --enable-python3interp                    \
            --with-tlib=ncursesw                      \
            --disable-darwin                          \
            --disable-selinux                         \
            --disable-gui                             \
            --disable-netbeans                        \
            --enable-cscope                           \
            --with-compiledby="Ali Hassani"           \
            --prefix=${LOCALDIR} &&                   \
            make -j$NUM_WORKERS VERBOSE=1 && \
            make install

        if [ $? -ne 0 ]; then
            echo "vim build failed."
            cd $THISDIR
            rm -rf $TMPDIR
            return 1
        fi

        cd $THISDIR
        rm -rf $TMPDIR
    else
        echo "ncurses not found! Vim requires ncurses!"
        return 1
    fi
}

configure_vim() {
    # Replace the vim files
    echo "Linking vim files..."
    rm -r $HOMEDIR/.vim
    rm -r $HOMEDIR/.vimrc
    ln -s $THISDIR/vim $HOMEDIR/.vim
    ln -s $THISDIR/vimrc $HOMEDIR/.vimrc

    # Separate directory to hold persistent undo history
    mkdir -p $HOMEDIR/.vimfiles/undodir

    # Swap dir
    mkdir -p $HOMEDIR/.vimfiles/swapdir
}
