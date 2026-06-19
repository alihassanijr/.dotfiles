#!/bin/bash
# Fzf builder
# Fuzzy finder

FZF_VERSION="0.73.1"

install_fzf() {
    local TMPDIR=$(build_tmpdir fzf)
    local PACKAGEURL="https://github.com/junegunn/fzf/archive/refs/tags/v$FZF_VERSION.tar.gz"
    local PACKAGETARNAME="fzf-$FZF_VERSION.tar.gz"
    local PACKAGEDIRNAME="fzf-$FZF_VERSION"

    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        fetch_package $PACKAGETARNAME $PACKAGEURL && \
        tar -xzf $PACKAGETARNAME && \
        rm $PACKAGETARNAME && \
        cd $PACKAGEDIRNAME && ./install --key-bindings --completion --no-update-rc && \
        cd $TMPDIR && \
        rm -rf $HOMEDIR/.fzf && \
        cp -r $PACKAGEDIRNAME $HOMEDIR/.fzf

    if [ $? -ne 0 ]; then
        echo "fzf build failed."
        cd $THISDIR
        rm -rf $TMPDIR
        return 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
