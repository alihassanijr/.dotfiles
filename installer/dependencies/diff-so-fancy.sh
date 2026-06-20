#!/bin/bash
# Diff-so-fancy
# The main script resolves its lib/ relative to itself (via abs_path($0)),
# so we install the whole package under $LOCALDIR/extras and point a *relative*
# symlink at it from $LOCALDIR/bin (relocatable; survives a shipped tree).

DIFF_SO_FANCY_VERSION="1.4.10"

install_diff_so_fancy() {
    echo "Setting up diff-so-fancy"
    local TMPDIR=$(build_tmpdir diff_so_fancy)
    local PACKAGEURL="https://github.com/so-fancy/diff-so-fancy/archive/refs/tags/v$DIFF_SO_FANCY_VERSION.tar.gz"
    local PACKAGETARNAME="diff-so-fancy-$DIFF_SO_FANCY_VERSION.tar.gz"
    local PACKAGEDIRNAME="diff-so-fancy-$DIFF_SO_FANCY_VERSION"

    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        fetch_package $PACKAGETARNAME $PACKAGEURL && \
        tar -xzf $PACKAGETARNAME && \
        rm $PACKAGETARNAME && \
        mkdir -p $LOCALDIR/extras && \
        rm -rf $LOCALDIR/extras/diff-so-fancy && \
        cp -r $PACKAGEDIRNAME $LOCALDIR/extras/diff-so-fancy && \
        rm -f $LOCALDIR/bin/diff-so-fancy && \
        ln -s ../extras/diff-so-fancy/diff-so-fancy $LOCALDIR/bin/diff-so-fancy

    if [ $? -ne 0 ]; then
        echo "diff-so-fancy build failed."
        cd $THISDIR
        rm -rf $TMPDIR
        return 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}

configure_diff_so_fancy() {
    # Have git use diff-so-fancy instead of diff
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global interactive.diffFilter "diff-so-fancy --patch"
    git config --global color.ui true

    git config --global color.diff-highlight.oldNormal    "red bold"
    git config --global color.diff-highlight.oldHighlight "red bold 52"
    git config --global color.diff-highlight.newNormal    "green bold"
    git config --global color.diff-highlight.newHighlight "green bold 22"

    git config --global color.diff.meta       "11"
    git config --global color.diff.frag       "magenta bold"
    git config --global color.diff.func       "146 bold"
    git config --global color.diff.commit     "yellow bold"
    git config --global color.diff.old        "red bold"
    git config --global color.diff.new        "green bold"
    git config --global color.diff.whitespace "red reverse"
}
