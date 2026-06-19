#!/bin/bash

CMATRIX_VERSION="2.0"

install_cmatrix() {
  if [[ "$BUILD_ONLY" -eq 1 ]]; then
    echo "Skip cmatrix in BUILD_ONLY -- not a requirement for most cases"
    return 0
  fi

  if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
    local TMPDIR=$(build_tmpdir cmatrix)
    local PACKAGEURL="https://github.com/abishekvashok/cmatrix/archive/refs/tags/v$CMATRIX_VERSION.tar.gz"
    local PACKAGETARNAME="cmatrix-$CMATRIX_VERSION.tar.gz"
    local PACKAGEDIRNAME="cmatrix-$CMATRIX_VERSION"

    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR

    # MacOS fix
    local ADDITIONAL_C_FLAGS="-I$NCDIR/include/ncursesw"
    local ADDITIONAL_LINKER_FLAGS=""
    if [[ "$_OS_NAME" = "darwin" ]]; then
      ADDITIONAL_C_FLAGS="$ADDITIONAL_C_FLAGS -D_DARWIN_C_SOURCE -DNCURSES_WIDECHAR"
      ADDITIONAL_LINKER_FLAGS="$ADDITIONAL_LINKER_FLAGS -Wl,-search_paths_first"
    fi

    # Out-of-source cmake build so the extracted source stays clean.
    cd $TMPDIR && \
      fetch_package $PACKAGETARNAME $PACKAGEURL && \
      tar -xzf $PACKAGETARNAME && \
      rm $PACKAGETARNAME && \
      mkdir -p build && \
      cd build && \
      cmake \
        -DCMAKE_INSTALL_PREFIX=$LOCALDIR \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
        -DCMAKE_C_FLAGS="$ADDITIONAL_C_FLAGS" \
        -DCURSES_INCLUDE_DIR=$NCDIR/include \
        -DCURSES_LIB_DIR=$NCDIR/lib \
        -DCURSES_LIBRARIES=-lncursesw \
        -DCMAKE_EXE_LINKER_FLAGS=$ADDITIONAL_LINKER_FLAGS \
        ../$PACKAGEDIRNAME && \
      make -j$NUM_WORKERS VERBOSE=1 && \
      make install

    if [ $? -ne 0 ]; then
      echo "cmatrix build failed."
      cd $THISDIR
      rm -rf $TMPDIR
      return 1
    fi

    cd $THISDIR
    rm -rf $TMPDIR
  else
    echo "ncurses not found! cmatrix requires ncurses!"
    return 1
  fi
}
