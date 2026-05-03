---
name: Preserve code comments in walkthroughs
description: When walking through code with user, do not strip comments when quoting snippets - they often contain key context
type: feedback
---

Walk user through code (tutorial, review, explain): keep inline comments in snippets by default. Strip or condense only when a comment is clearly irrelevant to the focus.

**Why:** Inline comments often answer the next question when code is being explained. Stripping is OK only for obvious or trivial fluff, such as `# figure out shape` above `shape = tensor.shape`.

**How to apply:** When showing code blocks in walkthroughs or reviews, copy comments verbatim by default. Trim only when a comment has no bearing on what is explained.
