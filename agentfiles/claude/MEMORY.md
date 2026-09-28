Project-specific memories (findings, rulings, style decisions made during one project's work) go in `<repo>/.claude/memory/`, indexed in `<repo>/.claude/MEMORY.md`. Never here. `~/.claude/projects/<hash>/memory/` is acceptable but not preferred; search it too when recalling. Global memory files: rule + How to apply only. No Why section, no project/tool/system/host names, no dates, no session details.
Before saving ask "true outside this repo?" No: project dir. Yes: here, written generic.

# ALWAYS READ
- [RARELY USE GENERAL KNOWLEDGE](memory/feedback-rarely-use-general-knowledge.md) — answer from fetched docs/code, not pretraining memory, unless indisputable; else say "not in sources"
- [Environment](memory/feedback-environment-never-assume.md) — custom PATH/LD_LIBRARY_PATH, split edit/build/run machines, GNU on mac, shell usually zsh; never probe, build, run, or touch outside working dir; `python3` not venv path; ask
- [Git](memory/feedback-never-touch-git-state.md) — no state-changing git unless user says git OK; user owns commits; "leave git to me" = no git at all; plain rm/mv
- [No compound requests](memory/feedback-no-compound-requests.md) — one simple bash command per call; one MCP/external read per turn

# Context-dependent
- [Style](memory/feedback-style.md) — no single-letter names except M, N, loop indices; constants CamelCase, ALL_CAPS only macros; column 100; never remove comments
- [Presentation](memory/feedback-presentation.md) — label files as reference vs edit; quoted code keeps inline comments verbatim
- [Test rules](memory/feedback-test-rules.md) — always verbose: lit -a/-v, pytest -v, ctest -V
