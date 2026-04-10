---
layout: default
title: weightedNormalEquations
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 22
mathjax: true
---

#  weightedNormalEquations

Assemble weighted normal equations.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 [normalMatrix,rhs] = weightedNormalEquations(X,x,W)
```
## Parameters
+ `X`  design matrix
+ `x`  observed values
+ `W`  weight matrix, vector, scalar, or decomposition

## Returns
+ `normalMatrix`  weighted normal-equation matrix
+ `rhs`  weighted normal-equation right-hand side

## Discussion

  For the weighted least-squares problem

  $$
  \min_{\xi}\ (x - X\xi)^T W (x - X\xi),
  $$

  this helper returns the normal matrix and right-hand side

  $$
  N = X^T W X, \qquad r = X^T W x.
  $$

  `W` may be a dense matrix, a diagonal weight vector, a scalar, or a
  MATLAB `decomposition` object representing a correlated observation
  covariance solve.


