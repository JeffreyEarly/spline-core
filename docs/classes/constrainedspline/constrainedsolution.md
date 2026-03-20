---
layout: default
title: ConstrainedSolution
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 2
mathjax: true
---

#  ConstrainedSolution

Solve the constrained weighted least-squares spline system.


---

## Declaration
```matlab
 [coefficients,CmInv,cachedVars] = ConstrainedSolution(t,x,K,tKnot,distribution,W,constraints,cachedVars)
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
+ `coefficients`  fitted spline coefficients
+ `CmInv`  inverse coefficient covariance or system matrix
+ `cachedVars`  updated cache of precomputed matrices

## Discussion

  Supports local equality constraints and optional global shape
  constraints enforced through quadratic programming when needed.
 
                          
