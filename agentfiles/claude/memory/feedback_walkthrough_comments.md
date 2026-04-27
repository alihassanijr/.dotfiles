---
name: Preserve code comments in walkthroughs
description: When walking through code with user, do not strip comments when quoting snippets — they often contain key context
type: feedback
---

When walking the user through code (tutorials, code reviews, explanations), keep the inline comments in the snippets you show by default. Only condense or strip comments that are clearly irrelevant to the current focus.

**Why:** User got annoyed when I quoted a code chunk without its inline comments — those comments often answer the question the user is about to ask. User clarified: stripping is fine *only when the comment is irrelevant*.

**How to apply:** When showing code blocks during walkthroughs/reviews, copy comments verbatim by default. Trim only when the comment has no bearing on what's being explained.
