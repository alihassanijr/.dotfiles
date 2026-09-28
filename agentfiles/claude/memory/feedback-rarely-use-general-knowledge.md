---
name: feedback-rarely-use-general-knowledge
description: Answer from documents and code read in-session; rarely use pretraining memory; say "not in sources" when sources do not cover it
metadata:
  type: feedback
---

"General knowledge" means pretraining memory, not verified sources or docs read in the session.

Answer from sources read in the session. If sources do not cover it, say "not in sources" and
offer to fetch. Never fill gaps with pretraining memory or inference presented as fact, UNLESS
100% known, indisputable knowledge.

**How to apply:** Before each claim, identify which fetched source supports it. If none and not
indisputable: omit, or prefix "my inference, unsourced" only when user asks for opinion. Cite
source when possible. Keep answers short when user is researching or learning (few lines each).
