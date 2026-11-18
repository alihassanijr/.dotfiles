---
name: feedback-torch-cute-strides-not-shapes
description: PyTorch x CuTe(DSL) - never change SHAPE to reconcile walk order or to transpose; change STRIDES only. Shape is canonical.
metadata:
  type: feedback
---

Handing a torch tensor to CuTe: shape is `tuple(t.shape)`, verbatim. Strides carry the layout.
Never reverse, swap, or reshape to "match CuTe's index order". Never change shape to transpose
memory order.

**Why:**
- CuTe's 1-D index walks the first mode fastest (colexicographic). torch's flatten walks the last
  mode fastest (lexicographic). That is a property of the walk, not of the tensor.
- Reversing shape makes the two walks agree but flips every coordinate: `T[n, m]` reads `A[m, n]`.

**Proof** (pycute over torch memory):

2-D, `A = arange(12).reshape(3, 4)`

| case | torch shape:stride | CuTe layout | `T[c] == A[c]` |
|---|---|---|---|
| row-major | (3,4):(4,1) | (3,4):(4,1) | yes |
| column-major relayout | (3,4):(1,3) | (3,4):(1,3) | yes, same values |
| reversed shape, same memory | - | (4,3):(1,4) | no. `T[0,1]=4`, `A[0,1]=1` |
| `.transpose(-1,-2)` view | (4,3):(1,4) | (4,3):(1,4) | no. Shape changed, different tensor |

```
1-D walk, same tensor (3,4):(4,1)
  CuTe  walk : 0 4 8 1 5 9 2 6 10 3 7 11
  torch walk : 0 1 2 3 4 5 6 7 8 9 10 11

memory order, same shape (3,4)
  row-major    (4,1) : 0 1 2 3 4 5 6 7 8 9 10 11
  column-major (1,3) : 0 4 8 1 5 9 2 6 10 3 7 11
```

3-D, `X = arange(24).reshape(2, 3, 4)`

| case | torch shape:stride | CuTe layout | `T[c] == X[c]` |
|---|---|---|---|
| row-major | (2,3,4):(12,4,1) | (2,3,4):(12,4,1) | yes |
| column-major relayout | (2,3,4):(12,1,3) | (2,3,4):(12,1,3) | yes, same values |
| reversed shape, same memory | - | (4,3,2):(1,4,12) | no. `T[0,0,1]=12`, `X[0,0,1]=1` |
| `.transpose(-1,-2)` view | (2,4,3):(12,1,4) | (2,4,3):(12,1,4) | no. Shape changed, different tensor |

```
1-D walk, same tensor (2,3,4):(12,4,1)
  CuTe  walk : 0 12 4 16 8 20 1 13 5 17 9 21 2 14 6 18 10 22 3 15 7 19 11 23
  torch walk : 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23

memory order, same shape (2,3,4)
  row-major    (12,4,1) : 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
  column-major (12,1,3) : 0 4 8 1 5 9 2 6 10 3 7 11 12 16 20 13 17 21 14 18 22 15 19 23
```

4-D, `Y = arange(120).reshape(2, 3, 4, 5)`

| case | torch shape:stride | CuTe layout | `T[c] == Y[c]` |
|---|---|---|---|
| row-major | (2,3,4,5):(60,20,5,1) | (2,3,4,5):(60,20,5,1) | yes |
| column-major relayout | (2,3,4,5):(60,20,1,4) | (2,3,4,5):(60,20,1,4) | yes, same values |
| reversed shape, same memory | - | (5,4,3,2):(1,5,20,60) | no. `T[0,0,0,1]=60`, `Y[0,0,0,1]=1` |
| `.transpose(-1,-2)` view | (2,3,5,4):(60,20,1,5) | (2,3,5,4):(60,20,1,5) | no. Shape changed, different tensor |

**How to apply:**
- Bridge: `Layout(tuple(t.shape), tuple(t.stride()))`.
- Column-major operand: keep shape, swap the two strides. `(M,N):(N,1)` to `(M,N):(1,M)`.
  Torch: `t.transpose(-1,-2).contiguous().transpose(-1,-2)`.
- `.t()`, `.transpose`, `.view(N, M)`, reversed shape: only when the logical tensor is meant to
  be the transpose.
