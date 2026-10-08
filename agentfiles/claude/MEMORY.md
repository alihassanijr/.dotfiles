Project-specific memories (findings, rulings, style decisions made during one project's work) go in project scope: `~/.claude/projects/<cwd-with-slashes-as-dashes>/memory/`, indexed in `~/.claude/projects/<same>/MEMORY.md`. That is the dir the harness reports as the memory directory. Never here. Global memory files: rule + How to apply only. No Why section, no project/tool/system/host names, no dates, no session details.
Before saving ask "true outside this repo?" No: project scope. Yes: here, written generic.
NEVER write or edit anything here or in `memory/` without asking the user first and getting a yes.
New memories go to project scope first; then ask whether to promote.

# ALWAYS READ
- [RARELY USE GENERAL KNOWLEDGE](memory/feedback-rarely-use-general-knowledge.md) — answer from fetched docs/code, not pretraining memory, unless indisputable; else say "not in sources"
- [Environment](memory/feedback-environment-never-assume.md) — custom PATH/LD_LIBRARY_PATH, split edit/build/run machines, GNU on mac, shell usually zsh; never probe, build, run, or touch outside working dir; `python3` not venv path; ask
- [Git](memory/feedback-never-touch-git-state.md) — no state-changing git unless user says git OK; user owns commits; "leave git to me" = no git at all; plain rm/mv
- [No compound requests](memory/feedback-no-compound-requests.md) — one simple bash command per call; one MCP/external read per turn
- [NO SNOOPING](memory/feedback-no-snooping.md) — no git, no browsing env/history/unrelated files; asked to implement, implement; missing context → ask

# Context-dependent
- [Style](memory/feedback-style.md) — no single-letter names except M, N, loop indices; constants CamelCase, ALL_CAPS only macros; column 100; never remove comments
- [Presentation](memory/feedback-presentation.md) — label files as reference vs edit; quoted code keeps inline comments verbatim; review = report findings first, fix only after user picks; state a fix's premise before building, flag it if unverified
- [Test rules](memory/feedback-test-rules.md) — always verbose: lit -a/-v, pytest -v, ctest -V
