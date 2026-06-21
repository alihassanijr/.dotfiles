.PHONY=install

WORKERS ?= 1
BUILD_ONLY ?= 0
PROGRAMS_PATH ?= 
IS_PERSONAL ?= 0

all: install

install:
	@NUM_WORKERS=$(WORKERS) BUILD_ONLY=$(BUILD_ONLY) ./install.sh
