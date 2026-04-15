#!/bin/bash

install_cmatrix() {
  if [[ -f "$NCDIR/bin/ncursesw6-config" ]]; then
    local PATH_TO_CMATRIX="$THISDIR/third_party/misc/cmatrix/"

    # Create a temporary directory
    local TEMP_DIR=$(mktemp -d)
    if [[ ! -d "$TEMP_DIR" ]]; then
        echo "Failed to create temporary directory. Exiting..."
        exit 1
    fi

    # Change to the temporary directory
    cd "$TEMP_DIR" || { echo "Failed to switch to temp directory. Exiting..."; exit 1; }

    # MacOS fix
    local ADDITIONAL_C_FLAGS="-I$NCDIR/include/ncursesw"
    local ADDITIONAL_LINKER_FLAGS=""
    if [[ "$OSTYPE" = "darwin"* ]]; then
      local ADDITIONAL_C_FLAGS="$ADDITIONAL_C_FLAGS -D_DARWIN_C_SOURCE -DNCURSES_WIDECHAR"
      local ADDITIONAL_LINKER_FLAGS="$ADDITIONAL_LINKER_FLAGS -Wl,-search_paths_first"
    fi

    cmake \
      -DCMAKE_INSTALL_PREFIX=$LOCALDIR \
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
      -DCMAKE_C_FLAGS="$ADDITIONAL_C_FLAGS" \
      -DCURSES_INCLUDE_DIR=$NCDIR/include \
      -DCURSES_LIB_DIR=$NCDIR/lib \
      -DCURSES_LIBRARIES=-lncursesw \
      -DCMAKE_EXE_LINKER_FLAGS=$ADDITIONAL_LINKER_FLAGS \
      $PATH_TO_CMATRIX 

    if [ "$?" -ne 0 ]; then
      echo "Setting up cmake for building cmatrix failed!"
      cd $THISDIR
      return 1
    fi

    make -j$NUM_WORKERS VERBOSE=1
    if [ "$?" -ne 0 ]; then
      echo "Building cmatrix failed!"
      cd $THISDIR
      return 1
    fi

    make install
    if [ "$?" -ne 0 ]; then
      echo "Installing cmatrix failed?!"
      cd $THISDIR
      return 1
    fi

    echo "cmatrix was built successfully."
    cd $THISDIR
  else
    echo "ncurses not found! cmatrix requires ncurses!"
    return 1
  fi
}

