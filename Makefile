.PHONY=install test-claude-hooks

WORKERS ?=
BUILD_ONLY ?= 0
PROGRAMS_PATH ?= 
IS_PERSONAL ?= 

all: install

install:
	@NUM_WORKERS=$(WORKERS) \
		BUILD_ONLY=$(BUILD_ONLY) \
		PROGRAMS_PATH=$(PROGRAMS_PATH) \
		IS_PERSONAL=$(IS_PERSONAL) ./install.sh

# Claude Code PreToolUse guard: decision tests, then per-call timing.
test-claude-hooks:
	sh agentfiles/claude/hooks/test_guard.sh
	sh agentfiles/claude/hooks/time_guard.sh
