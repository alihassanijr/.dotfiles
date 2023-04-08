#!/bin/bash
# Aria2 builder
# File downloader

install_aria2() {
    # Build
    cd $THISDIR/third_party/aria2/ && \
        autoreconf -i && \
        ./configure ARIA2_STATIC=yes && \
        make && \
        make check
    # Move to .local/bin
    mv $THISDIR/third_party/aria2/src/aria2c $LOCALDIR/bin/aria2c
    # Cleanup
    cd $THISDIR/third_party/aria2/ && \
        git stash && \
        git stash drop

    cd $THISDIR
}
