---
name: feedback-environment-never-assume
description: User env is custom (PATH, LD_LIBRARY_PATH, self-built tools, GNU on mac, split edit/build/run machines, shell usually zsh). Never probe or assume anything about it; ask.
metadata:
  type: feedback
---

User environment is not typical. Custom PATH, LD_LIBRARY_PATH, self-built programs, custom
build setup. Current machine may be edit-only, build-only, run-only, or all three. On mac user
builds GNU programs (coreutils, bash, etc.): do not assume POSIX/BSD tool flavor or flags. Shell
is usually zsh; do not assume shell or its builtins.

**How to apply:**
- Never assume where python, compiler, linker, libraries, or any tool live. Ask.
- Tool not on PATH: stop, ask user where it is or how to load it. No `find`, `Glob`, `ls`,
  `which`, `--version`, `env`, `pip show`, or listing install dirs to locate it.
- Never run `python`, `pip`, `pytest`, compilers, or tests without first asking which
  interpreter/env/machine is correct. Use Read/Grep/Glob inside working dir to read source.
- Python venv: user always activates it. Write `python3`, never `.../.venv/bin/python3` or any
  interpreter path.
- Do not compile, run, or test unless asked in the current turn. After writing code, stop and
  report. If a build would help, ask "want me to build?".
- Do not read, list, inspect, or modify anything outside working dir without asking. Reading
  counts.
- "proceed" after a question means continue with stated assumptions, not probe.
