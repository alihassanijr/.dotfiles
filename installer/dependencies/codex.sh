#!/bin/bash
# Codex
# Prebuilt release binary from openai/codex (musl on Linux, universal-ish on mac).

CODEX_VERSION="0.141.0"

install_codex() {
    local TMPDIR=$(build_tmpdir codex)
    local arch="$(uname -m)"
    local tag=""

    if [[ "$_OS_NAME" == "darwin" ]] && [[ "$arch" == "arm64" || "$arch" == "aarch64" ]]; then
        tag="aarch64-apple-darwin"
    elif [[ "$_OS_NAME" == "darwin" ]] && [[ "$arch" == "x86_64" ]]; then
        tag="x86_64-apple-darwin"
    elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then
        tag="aarch64-unknown-linux-musl"
    elif [[ "$_OS_NAME" == "linux" ]] && [[ "$arch" == "x86_64" ]]; then
        tag="x86_64-unknown-linux-musl"
    fi

    if [[ "$tag" == "" ]]; then
        echo "Failed to install codex: unsupported platform $_OS_NAME/$arch."
        return 1
    fi

    local PACKAGEURL="https://github.com/openai/codex/releases/download/rust-v$CODEX_VERSION/codex-$tag.tar.gz"
    local PACKAGETARNAME="codex-$tag.tar.gz"

    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    cd $TMPDIR && \
        fetch_package $PACKAGETARNAME $PACKAGEURL && \
        tar -xzf $PACKAGETARNAME && \
        rm $PACKAGETARNAME && \
        mkdir -p $LOCALDIR/bin && \
        mv codex-$tag $LOCALDIR/bin/codex && \
        chmod +x $LOCALDIR/bin/codex

    if [ $? -ne 0 ]; then
        echo "codex build failed."
        cd $THISDIR
        rm -rf $TMPDIR
        return 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
}
