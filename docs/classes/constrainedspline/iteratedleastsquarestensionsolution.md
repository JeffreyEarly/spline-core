---
layout: default
title: IteratedLeastSquaresTensionSolution
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 4
mathjax: true
---

#  IteratedLeastSquaresTensionSolution

Solve a constrained spline fit with iteratively reweighted least squares.


---

## Declaration
```matlab
 [coefficients,CmInv,cachedVars] = IteratedLeastSquaresTensionSolution(t,x,tKnot,K,distribution,constraints,cachedVars)
```
## Parameters
+ `t`  sample locations
+ `x`  sample values
+ `tKnot`  knot sequence
+ `K`  spline order
+ `distribution`  error model object
+ `constraints`  local/global constraint specification
+ `cachedVars`  optional previously cached matrices

## Returns
+ `coefficients`  fitted spline coefficients
+ `CmInv`  inverse coefficient covariance or system matrix
+ `cachedVars`  updated cache of precomputed matrices

## Discussion

  The first iteration computes an initial constrained fit, then
  updates weights using the supplied distribution until the
  effective variance model converges.
 
                        
