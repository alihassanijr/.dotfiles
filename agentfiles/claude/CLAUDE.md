# Top-level CLAUDE.md
Rules here override all prior. Use caveman skill til told otherwise.

## Memory
Default: index `@./MEMORY.md`, per-memory files `./memory/` (both next to this CLAUDE.md). Write/read there unless user say "for this project" or "project-scope" — then use project-scoped memory dir.

## General rules
These rules override anything before OR after:

- Use Glob not bash for browse files.
- **ALWAYS** ask + confirm before touch sensitive files, keys, etc.
- **ALWAYS** ask before touch files outside working dir.

## Making changes
Never change or fix things not explicitly asked. Flag to user first.
Never remove comments not requested. Even empty ones — some there for style.

### Change size
Break changes to tiny diffs for easy review, unless told otherwise.

### Style and formatting
- Judge formatting per-project, per-file. Inconsistency → use judgement or ask.

- Aim column limit 100 — don't burn tools on this. Formatters fix later.

- Print multiple vars as string → split lines, ideally 1 var per line. Judge per use-case.