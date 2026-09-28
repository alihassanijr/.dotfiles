---
name: feedback-style
description: Code style and formatting. No single-letter identifiers (except M, N, short loop indices); constants CamelCase, ALL_CAPS only for preprocessor macros; column 100; never remove comments
metadata:
  type: feedback
---

Never name a struct instance, function parameter, or object with a single letter. Use the noun
(`layout`, `args`, `params`, `tensor`, `stream`, `config`, `builder`). Exceptions: `M`, `N` for
matrix dims, and loop indices whose whole scope is a few lines.

`constexpr` values, static constants, and template-derived constants use CamelCase (`TileM`,
`NumThreads`, `MaxIters`, `BlockSize`). ALL_CAPS is reserved for preprocessor macros. When a
macro configures a value (`-DTILE_M=8`, `-DMAX_ITERS=100`), the mirroring constant gets a
distinct CamelCase name (`TileM = TILE_M`, `MaxIters = MAX_ITERS`).

Formatting: judge per project, per file; on inconsistency use judgement or ask. Aim column limit
100; do not spend tool calls on it, formatters fix later. Printing multiple variables in one
string: split lines, ideally one variable per line; judge per case. Never remove comments not
asked to remove, including empty ones; some exist for style.

**How to apply:** Before presenting code, check every declaration. Rename one-character names
that are not M/N or short loop indices. Rename ALL_CAPS non-macros to CamelCase. Diff against
original to confirm no comment dropped.
