---
layout: default
title: PrecomputeSolutionMatrices
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 6
mathjax: true
---

#  PrecomputeSolutionMatrices

Precompute reusable matrices for constrained spline fitting.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 cachedVars = PrecomputeSolutionMatrices(t,x,K,tKnot,distribution,W,constraints,cachedVars)
```
## Parameters
+ `t`  sample locations
+ `x`  sample values
+ `K`  spline order
+ `tKnot`  knot sequence
+ `distribution`  error model object
+ `W`  optional weights or weight matrix
+ `constraints`  local/global constraint specification
+ `cachedVars`  optional previously cached matrices

## Returns
+ `cachedVars`  struct of precomputed matrices

## Discussion

                        
