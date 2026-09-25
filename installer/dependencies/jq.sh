#!/usr/bin/env bash
# jq: command-line JSON processor

JQ_VERSION="1.8.2"

install_jq() {

  # Dependency: libtool
  source installer/dependencies/libtool.sh
  check_and_install_dependency "libtool" "$LOCALDIR/bin/libtool" "install_libtool" || {
    echo "jq dependency resolution failed. Won't attempt build.";
    return 1
  }

  local TMPDIR=$(build_tmpdir jq)
  local PACKAGEREPO="https://github.com/jqlang/jq.git"
  local PACKAGEDIRNAME="jq-$JQ_VERSION"

  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR

  cd $TMPDIR && \
    git clone --depth 1 --branch jq-$JQ_VERSION $PACKAGEREPO $PACKAGEDIRNAME && \
    cd $PACKAGEDIRNAME && \
    git submodule update --init && \
    autoreconf -i && \
    ./configure \
      --prefix=${LOCALDIR} \
      --with-oniguruma=builtin && \
    make -j$NUM_WORKERS LDFLAGS=-all-static && \
    make install

  if [ $? -ne 0 ]; then
    echo "jq build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi

  cd $THISDIR
  rm -rf $TMPDIR
}
