#!/bin/bash
# clang-format

CLANG_FORMAT_VERSION="18.1.0"

install_clang_format() {
    # Create a temporary directory
    local TEMP_DIR=$(mktemp -d)
    if [[ ! -d "$TEMP_DIR" ]]; then
        echo "Failed to create temporary directory. Exiting..."
        exit 1
    fi

    local LLVM_URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-${CLANG_FORMAT_VERSION}/llvm-${CLANG_FORMAT_VERSION}.src.tar.xz
    local CLANG_URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-${CLANG_FORMAT_VERSION}/clang-${CLANG_FORMAT_VERSION}.src.tar.xz
    local CMAKE_URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-${CLANG_FORMAT_VERSION}/cmake-${CLANG_FORMAT_VERSION}.src.tar.xz
    local THIRD_PARTY_URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-${CLANG_FORMAT_VERSION}/third-party-${CLANG_FORMAT_VERSION}.src.tar.xz

    # Change to the temporary directory
    cd "$TEMP_DIR" || { echo "Failed to switch to temp directory. Exiting..."; exit 1; }

    # Download release
    wget $LLVM_URL
    wget $CLANG_URL
    wget $CMAKE_URL
    wget $THIRD_PARTY_URL

    local expected_tars=(
      llvm-${CLANG_FORMAT_VERSION}.src.tar.xz
      clang-${CLANG_FORMAT_VERSION}.src.tar.xz
      cmake-${CLANG_FORMAT_VERSION}.src.tar.xz
      third-party-${CLANG_FORMAT_VERSION}.src.tar.xz
    )

    # Decompress
    for file in "${expected_tars[@]}"; do
        if [[ ! -f "$file" ]]; then
            echo "File $file failed to download. Exiting..."

            # Tear-down
            cd $THISDIR
            rm -rf $TEMP_DIR

            return 1
        fi

        tar -xf $file || { echo "Failed to decompress $file. Exiting..."; cd $THISDIR; rm -rf $TEMP_DIR; return 1;}

        expected_dir=${file/.tar.xz//}
        target_dir=${expected_dir/-${CLANG_FORMAT_VERSION}.src//}

        if [[ ! -d "$expected_dir" ]]; then
            echo "Expected directory $expected_dir, but it doesn't exist. Exiting..."

            # Tear-down
            cd $THISDIR
            rm -rf $TEMP_DIR

            return 1
        fi

        mv $expected_dir $target_dir
    done

    # Build clang-format
    mkdir build && cd build
    cmake ../llvm/ -DLLVM_ENABLE_PROJECTS="clang" -DCMAKE_BUILD_TYPE=Release -DLLVM_INCLUDE_BENCHMARKS=OFF
    make clang-format -j$NUM_WORKERS

    # Check result and Move
    if [[ -f bin/clang-format ]]; then
      cp bin/clang-format $LOCALDIR/bin/
      echo "Installed clang-format successfully."
    else
      echo "clang-format FAILED to build."
    fi

    # Tear-down
    cd $THISDIR
    rm -rf $TEMP_DIR
}
