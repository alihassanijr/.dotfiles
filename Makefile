.PHONY=install

all: install

install:
	./install.sh

deps-ubuntu:
	sudo apt-get update -y
	sudo apt-get install zsh tmux autoconf autotools-dev pkg-config -y
