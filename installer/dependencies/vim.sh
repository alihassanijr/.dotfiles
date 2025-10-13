#!/bin/bash
# Vim builder
# Building vim from source because I want the same version of vim
# everywhere, and I want to decide when to upgrade or not.
# Even now most Ubuntu builds don't have vim9.

install_vim() {
    # Couple of notes:
    # A. I disable selinux because not all the servers I'm on have it installed
    #    so I'm not going to bother.
    # B. To get my local ncurses (really ncursesw) to be recognized, I added
    #    its path to LDFLAGS and CFLAGS.
    # C. Needed to explicitly use --disable-darwin to have it build normally on
    #    mac.
    # D. Obviously installing to ~/.local/bin -- sourced in commonrc.
    # E. I added the submodule to path third_party/vim9 because third_party/vim
    #    holds all the vim plugins, and I really don't want to move submodules now.
    if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
        cd $THISDIR/third_party/vim9/ && \
            make clean && make distclean &&           \
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
            make install && \
            make clean
        cd $THISDIR
    else
        echo "ncurses not found! Vim requires ncurses!"
        exit 1;
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
