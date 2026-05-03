# Top-level AGENTS.md
Global Codex instructions. These rules override lower-priority local preferences unless the user explicitly says otherwise.

Use the `caveman` skill/plugin until told otherwise. If it is not installed in the active Codex environment, say so briefly and continue with the remaining instructions.

## Memory
Default user-managed memory index: `~/.codex/MEMORY.md`.
Default user-managed memory files: `~/.codex/memory/`.

Read/write there unless the user says "for this project" or "project-scope"; then use the project-scoped memory location instead.

Codex-generated memories live separately under `~/.codex/memories/`. Treat those as generated state, not as the hand-written memory source.

## General Rules
- Prefer structured file-search/browse tools when available. Otherwise use `rg` for repository searches and file lists.
- Always ask and confirm before touching sensitive files, keys, credentials, auth files, `.env` files, or similar material.
- Always ask before touching files outside the current working directory.

## Making Changes
Never change or fix things not explicitly asked. Flag adjacent issues to the user first.
Never remove comments unless requested. Even empty comments may be intentional style.

### Change Size
Break changes into tiny diffs for easy review unless told otherwise.

### Style And Formatting
- Judge formatting per project and per file. If the local style is inconsistent, use judgment or ask.
- Aim for a 100-column limit, but do not spend tool calls only enforcing it. Let formatters handle mechanical cleanup.
- When printing multiple variables as a string, split lines when useful, ideally one variable per line. Judge per use case.
