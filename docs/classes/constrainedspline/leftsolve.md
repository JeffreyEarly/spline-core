---
layout: default
title: leftSolve
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 13
mathjax: true
---

#  leftSolve

Solve a linear system, falling back to a pseudoinverse if needed.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 x = leftSolve(A,b)
```
## Parameters
+ `A`  system matrix
+ `b`  right-hand side

## Returns
+ `x`  solution vector or matrix

## Discussion

  This is a defensive wrapper around left division. Sparse systems are
  solved directly with `A\b`. Dense systems first check the reciprocal
  condition number; if the matrix is effectively singular, the function
  falls back to `pinv(A)*b`.


