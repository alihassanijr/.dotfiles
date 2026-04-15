#!/bin/bash
# gnu sed

install_gnu_sed() {
  echo "Installing dependency: gnu sed"
  
  local TMPDIR=$THISDIR/tmp_gnu_sed
  local PACKAGEURL="https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz"
  local PACKAGETARNAME="sed-4.9.tar.xz"
  local PACKAGEDIRNAME="sed-4.9"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
  if [[ -d "$LOCALDIR/lib/perl5/" ]]; then
    export PERL5LIB=$LOCALDIR/lib/perl5/
  fi
  cd $TMPDIR && \
    wget $PACKAGEURL -O $PACKAGETARNAME && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./configure \
      --prefix=${LOCALDIR} \
      --disable-dependency-tracking && \
    make install
  
  cd $THISDIR
  rm -rf $TMPDIR
}
