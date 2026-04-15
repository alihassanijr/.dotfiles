#!/bin/bash
# Fzf builder
# Fuzzy finder

install_fzf() {
    cd $THISDIR/third_party/fzf/ && ./install
    cd $THISDIR
    rm -rf $HOMEDIR/.fzf
    ln -s $THISDIR/third_party/fzf $HOMEDIR/.fzf
    cd $THISDIR
}
