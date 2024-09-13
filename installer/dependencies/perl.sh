#!/bin/bash
# Perl

install_perl() {
  local TMPDIR=$THISDIR/tmp_perl
  local PACKAGEURL="https://www.cpan.org/src/5.0/perl-5.38.2.tar.xz"
  local PACKAGETARNAME="perl-5.38.2.tar.xz"
  local PACKAGEDIRNAME="perl-5.38.2"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR

  cd $TMPDIR && \
    wget $PACKAGEURL -O $PACKAGETARNAME && \
    tar -xf $PACKAGETARNAME && \
    rm $PACKAGETARNAME && \
    cd $PACKAGEDIRNAME && \
    ./Configure -des -Dinstallprefix=$LOCALDIR -Duselargefiles -Dusethreads && \
    make && \
    make install
  cd $THISDIR
  rm -rf $TMPDIR
}
