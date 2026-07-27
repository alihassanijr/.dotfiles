---
name: feedback-memory-scope-project-first
description: Project-specific memories go in the REPO's .claude/ (memory/ + MEMORY.md), never global — repeated angry correction
metadata:
  type: feedback
---

User (very angry, repeated correction): anything written about a SPECIFIC project — findings, rulings, style feedback given during that project's work — goes in the **repo's own `.claude/` directory** (`<repo>/.claude/memory/` + `<repo>/.claude/MEMORY.md`), never in the global `~/.claude/memory/`. NOTE: `~/.claude/projects/<hash>/` is ALSO wrong — that's still the global tree; the user means the working directory's `.claude/`.

**Why:** global memory is for cross-project facts only; project noise there pollutes every session, and the repo `.claude/` travels with the project.

**How to apply:** before saving a memory, ask "is this true outside this repo?" — no → `<repo>/.claude/memory/` and index in `<repo>/.claude/MEMORY.md` (matching its existing style). Global stays only for genuinely cross-project preferences like this one.
