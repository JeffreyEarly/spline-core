---
layout: default
title: monotonicDifferenceMatrix
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 12
mathjax: true
---

#  monotonicDifferenceMatrix

Build coefficient-difference inequalities along one dimension.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 A = monotonicDifferenceMatrix(basisSize,dim,direction)
```
## Parameters
+ `basisSize`  tensor basis size per dimension
+ `dim`  constrained tensor dimension
+ `direction`  "increasing" or "decreasing"

## Returns
+ `A`  sparse inequality matrix acting on xi(:)

## Discussion

  This helper constructs a sparse matrix `A` such that `A*xi <= 0`
  enforces adjacent coefficient differences of one sign along the selected
  tensor dimension.

  For the increasing case, each row encodes

  $$
  \xi_{j_1,\ldots,j_d} - \xi_{j_1,\ldots,j_k+1,\ldots,j_d} \le 0,
  $$

  so adjacent coefficients are nondecreasing along dimension `dim`. The
  decreasing case flips the sign pattern.


