.PHONY=install

WORKERS ?= 1

all: install

install:
	@NUM_WORKERS=$(WORKERS) ./install.sh

deps-ubuntu:
	sudo apt-get update -y
	sudo apt-get install zsh tmux autoconf autotools-dev pkg-config zip unzip -y
