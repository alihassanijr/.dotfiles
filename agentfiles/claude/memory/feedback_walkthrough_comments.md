---
name: Preserve code comments in walkthroughs
description: When walking through code with user, do not strip comments when quoting snippets — they often contain key context
type: feedback
---

Walk user thru code (tutorial, review, explain) — keep inline comments in snippets by default. Strip/condense only when comment clearly irrelevant to focus.

**Why:** User annoyed when quote code chunk minus inline comments — comments often answer next question. Strip OK *only* for obvious/trivial fluff (e.g. `# figure out shape` above `shape = tensor.shape`).

**How to apply:** Show code blocks in walkthrough/review → copy comments verbatim by default. Trim only when comment no bearing on what explained.
