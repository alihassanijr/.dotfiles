#!/bin/bash
# Diff-so-fancy
# It's a submodule, and comes with a static build
# so we just need to link it

install_diff_so_fancy() {
    echo "Setting up diff-so-fancy"
    rm -f $LOCALDIR/bin/diff-so-fancy
    ln -s $THISDIR/third_party/misc/diff-so-fancy/diff-so-fancy $LOCALDIR/bin/diff-so-fancy 
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
