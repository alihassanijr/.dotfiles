.PHONY=install

WORKERS ?= 1
BUILD_ONLY ?= 0

all: install

install:
	@NUM_WORKERS=$(WORKERS) BUILD_ONLY=$(BUILD_ONLY) ./install.sh

deps-ubuntu:
	sudo apt-get update -y
	sudo apt-get install zsh tmux autoconf autotools-dev pkg-config zip unzip -y
