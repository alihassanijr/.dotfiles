#!/bin/bash
# Cloudflare

install_go() {
  echo "Installing dependency: go"
	GO_VERSION="1.21.8"
  
  local TMPDIR=$THISDIR/tmp_go
  local arch="$(uname -m)"

  if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "arm64" ]]; then
    GOURL="https://storage.googleapis.com/golang/go${GO_VERSION}.darwin-arm64.tar.gz"
  elif [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
    GOURL="https://storage.googleapis.com/golang/go${GO_VERSION}.darwin-amd64.tar.gz"
  elif [[ "$OSTYPE" == "linux"* ]] && [[ "$arch" == "x86_64" ]]; then
    GOURL="https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz"
  elif [[ "$OSTYPE" == "linux"* ]] && [[ "$arch" == "arm" ]]; then
    GOURL="https://storage.googleapis.com/golang/go${GO_VERSION}.linux-arm64.tar.gz"
	fi

  if [[ "$GOURL" != "" ]]; then

    local PACKAGETARNAME="go${GO_VERSION}.tar.gz"
    local PACKAGEDIRNAME="go"
    
    cd $THISDIR
    rm -rf $TMPDIR
    mkdir -p $TMPDIR
    
    cd $TMPDIR && \
      wget $GOURL -O $PACKAGETARNAME && \
      tar -xzf $PACKAGETARNAME && \
      rm $PACKAGETARNAME && \
      mv $PACKAGEDIRNAME ${LOCALDIR} && \
			ln -s $LOCALDIR/go/bin/go $LOCALDIR/bin/go
    
    cd $THISDIR
    rm -rf $TMPDIR

  else
    echo "I haven't accounted for go on your setup: os=${OSTYPE}, arch=${arch}"
  fi
}

install_cloudflare_dependencies() {
  if [[ -d "$LOCALDIR/go" ]]; then
    echo "go is already installed, skipping..."
  else
    install_go
  fi
}

build_cloudflare() {
  local TMPDIR=$THISDIR/tmp_cloudflare
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
  
	cd $TMPDIR && \
    git clone https://github.com/cloudflare/cloudflared &&
		cd cloudflared && \
		git checkout 2024.2.1 && \
		go clean && \
    go get github.com/cloudflare/cloudflared/cmd/cloudflared && \
	  make cloudflared && \
		make install PREFIX=${LOCALDIR}

  cd $THISDIR
  rm -rf $TMPDIR
}

install_cloudflare() {
  install_cloudflare_dependencies
  build_cloudflare
}
