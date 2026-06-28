#!/usr/bin/env bash
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

        # Python3 dependency
        local FOUND_PYTHON3=0
        local ADDITIONAL_VIM_CONF_ARGS=""

        if program_exists "python3"; then
          # os python path
          local PYTHON_BIN=$(program_path "python3")
          local PYTHON_INCLUDE_PATH=$($PYTHON_BIN -c "import sysconfig; print(sysconfig.get_path('include'))")
          if [[ -d "$PYTHON_INCLUDE_PATH" && -f "$PYTHON_INCLUDE_PATH/Python.h" ]]; then
            echo "Python3 dependency resolved: $PYTHON_BIN"
            echo "Include dir: $PYTHON_INCLUDE_PATH"
            ADDITIONAL_VIM_CONF_ARGS="--enable-python3interp"
            FOUND_PYTHON3=1
          else
            echo "Incomplete python3 found at $PYTHON_BIN, include directories non-existent / invalid."
          fi
        fi

        echo "FOUND_PYTHON3: $FOUND_PYTHON3"
        echo "BASE: $PYTHON_BASE_VENV_DIR"
        if [[ $FOUND_PYTHON3 -eq 0 && -d "$PYTHON_BASE_VENV_DIR" && -f "$PYTHON_BASE_VENV_DIR/bin/python3" ]]; then
          # uv path
          local PYTHON_BIN=$PYTHON_BASE_VENV_DIR/bin/python3
          local PYTHON_INCLUDE_PATH=$($PYTHON_BIN -c "import sysconfig; print(sysconfig.get_path('include'))")

          echo "Found uv path python: $PYTHON_BASE_VENV_DIR"
          echo "Include dir: $PYTHON_INCLUDE_PATH"

          if [[ -d "$PYTHON_INCLUDE_PATH" && -f "$PYTHON_INCLUDE_PATH/Python.h" ]]; then
            echo "Python3 dependency resolved: $PYTHON_BIN"
            echo "Include dir: $PYTHON_INCLUDE_PATH"

            export PATH=$PYTHON_BASE_VENV_DIR/bin:$PATH
            export LD_LIBRARY_PATH=$PYTHON_BASE_VENV_DIR/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
            export CFLAGS="-I$PYTHON_INCLUDE_PATH"
            export CPPFLAGS="-I$PYTHON_INCLUDE_PATH"

            ADDITIONAL_VIM_CONF_ARGS="--enable-python3interp"
          fi
        fi

        echo "Installing vim with additional args: $ADDITIONAL_VIM_CONF_ARGS"

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
            --with-tlib=ncursesw                      \
            --disable-darwin                          \
            --disable-selinux                         \
            --disable-gui                             \
            --disable-netbeans                        \
            --enable-cscope                           \
            --with-compiledby="Ali Hassani"           \
            $ADDITIONAL_VIM_CONF_ARGS                 \
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

### LARGE PLUGINS

verify_sha256() {
    # Usage: verify_sha256 <file> <expected_hash>
    local FILE=$1
    local EXPECTED=$2
    local ACTUAL
    if program_exists shasum; then
        ACTUAL=$(shasum -a 256 "$FILE" | awk '{print $1}')
    elif program_exists sha256sum; then
        ACTUAL=$(sha256sum "$FILE" | awk '{print $1}')
    else
        echo "No sha256 tool (shasum/sha256sum) found; cannot verify $FILE."
        return 1
    fi
    if [[ "$ACTUAL" != "$EXPECTED" ]]; then
        echo "Hash mismatch for $FILE"
        echo "  expected: $EXPECTED"
        echo "  actual:   $ACTUAL"
        return 1
    fi
}

fetch_vim_pack_large_plugin() {
    # Usage: fetch_vim_pack_large_plugin <name> <url> <sha256> <tarball_topdir>
    local NAME=$1          # target dir name under vim/pack-large
    local URL=$2
    local SHA256=$3
    local TAR_TOPDIR=$4    # top-level dir inside the tarball

    local DEST="$THISDIR/vim/pack-large/$NAME"
    local STAMP="$DEST/.fetched"

    # Skip if we already fetched this exact version (verified by hash).
    if [[ -f "$STAMP" && "$(cat "$STAMP")" == "$SHA256" ]]; then
        echo "$NAME already fetched (hash matches); skipping."
        return 0
    fi

    local TMPDIR=$(build_tmpdir "vim-$NAME")
    rm -rf "$TMPDIR"
    mkdir -p "$TMPDIR"

    local TARBALL="$TMPDIR/$NAME.tar.gz"
    if ! fetch_package "$TARBALL" "$URL"; then
        echo "Failed to download $NAME."
        rm -rf "$TMPDIR"
        return 1
    fi

    # Verify the download before extracting.
    if ! verify_sha256 "$TARBALL" "$SHA256"; then
        echo "Refusing to extract $NAME."
        rm -rf "$TMPDIR"
        return 1
    fi

    if ! tar -xzf "$TARBALL" -C "$TMPDIR"; then
        echo "Failed to extract $NAME."
        rm -rf "$TMPDIR"
        return 1
    fi

    # Repopulate the (always-present) target dir with the extracted contents.
    mkdir -p "$DEST"
    rm -rf "$DEST"/* "$DEST"/.[!.]* 2>/dev/null
    mv "$TMPDIR/$TAR_TOPDIR"/* "$DEST"/
    mv "$TMPDIR/$TAR_TOPDIR"/.[!.]* "$DEST"/ 2>/dev/null

    # Stamp with the verified hash so reruns skip.
    echo "$SHA256" > "$STAMP"
    rm -rf "$TMPDIR"
    echo "Fetched $NAME ($SHA256) into $DEST"
}

fetch_vim_polyglot() {
    fetch_vim_pack_large_plugin \
        "vim-polyglot" \
        "https://github.com/vim-polyglot/vim-polyglot/archive/refs/tags/v4.17.0.tar.gz" \
        "358c2f39042c9c5ea9233d457f03e87da5c2ed0e72001cc01f4ba95a0ae08267" \
        "vim-polyglot-4.17.0"
}

fetch_vimtex() {
    fetch_vim_pack_large_plugin \
        "vimtex" \
        "https://github.com/lervag/vimtex/archive/refs/tags/v2.17.tar.gz" \
        "2eeb99147c06654e6908990f2f020435f3714d467d7cb02d7d04a4038ec64988" \
        "vimtex-2.17"
}

configure_vim() {
    # Replace the vim files
    echo "Linking vim files..."
    link_directory "$THISDIR/vim" "$HOMEDIR/.vim"
    link_file "$THISDIR/vimrc" "$HOMEDIR/.vimrc"

    # Separate directory to hold persistent undo history
    mkdir -p $HOMEDIR/.vimfiles/undodir

    # Swap dir
    mkdir -p $HOMEDIR/.vimfiles/swapdir

    # Larger plugins are downloaded and not shipped out with dotfiles
    fetch_vim_polyglot
    if [[ $IS_PERSONAL -eq 1 ]]; then
        fetch_vimtex
    fi
}
