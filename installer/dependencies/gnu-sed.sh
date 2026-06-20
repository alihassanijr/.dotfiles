#!/bin/bash
# gnu sed

SED_VERSION="4.9"

install_gnu_sed() {
  echo "Installing dependency: gnu sed"
  
  local TMPDIR=$(build_tmpdir gnu_sed)
  local PACKAGEURLS=(
    "https://ftpmirror.gnu.org/gnu/sed/sed-$SED_VERSION.tar.xz"
    "https://ftp.gnu.org/gnu/sed/sed-$SED_VERSION.tar.xz"
  )
  local PACKAGETARNAME="sed-$SED_VERSION.tar.xz"
  local PACKAGEDIRNAME="sed-$SED_VERSION"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  if [[ -d "$LOCALDIR/lib/perl5/" ]]; then
    export PERL5LIB=$LOCALDIR/lib/perl5/
  fi
  cd $TMPDIR && \
    fetch_package $PACKAGETARNAME "${PACKAGEURLS[@]}" && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./configure \
      --prefix=${LOCALDIR} \
      --disable-dependency-tracking && \
    make -j$NUM_WORKERS install

  if [ $? -ne 0 ]; then
    echo "gnu sed build failed."
    cd $THISDIR
    rm -rf $TMPDIR
    return 1
  fi

  cd $THISDIR
  rm -rf $TMPDIR
}
