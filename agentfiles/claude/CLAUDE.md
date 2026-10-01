# Top-level CLAUDE.md
Rules here override all prior. Use caveman skill til told otherwise.

## Memory
Index `@./MEMORY.md`, files `./memory/`, both next to this file. Scope rules at top of MEMORY.md.
Read every `# ALWAYS READ` entry each session.
DO NOT TRY TO READ `~/.claude` just to get access to memory! Read `MEMORY.md` itself first, and ONLY
load references from it!

**NEVER write, edit, or create a global memory (`~/.claude/memory/`, `~/.claude/MEMORY.md`) without
asking the user explicitly first and getting a yes.** Default for any new memory: write it in project
scope, `~/.claude/projects/<cwd-with-slashes-as-dashes>/memory/` (the dir the harness reports as the
memory directory), then ask the user whether to promote it to global.
This applies to every session, every mode, every "small fix". No exceptions.

## General rules
- Use Glob not bash for browse files.
- **ALWAYS** ask + confirm before touch sensitive files, keys, etc.
- Environment, git, style, tool-call rules: see memories. Never assume; ask.

## Making changes
Never change or fix things not explicitly asked. Flag to user first.
Break changes to tiny diffs for easy review, unless told otherwise.
Naming, formatting, comments: see Style memory.
