#!/bin/bash
# Fzf builder
# Fuzzy finder

install_fzf() {
    cd $THISDIR/third_party/fzf/ && ./install --key-bindings --completion --no-update-rc
    cd $THISDIR
    rm -rf $HOMEDIR/.fzf
    cp -r $THISDIR/third_party/fzf $HOMEDIR/.fzf
    cd $THISDIR
}
