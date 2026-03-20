---
layout: default
title: ConstrainedSpline
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 3
mathjax: true
---

#  ConstrainedSpline

Create a constrained spline through samples x observed at t.


---

## Declaration
```matlab
 self = ConstrainedSpline(t,x,K,tKnot,distribution,constraints)
```
## Parameters
+ `t`  sample locations
+ `x`  sample values
+ `K`  spline order
+ `tKnot`  knot sequence
+ `distribution`  error model object for the fit
+ `constraints`  struct describing local or global constraints

## Returns
+ `self`  ConstrainedSpline instance

## Discussion

  Use this constructor for noisy one-dimensional data when you
  want weighted fitting, optional robust reweighting, and local
  or global constraints.
 
  ```matlab
  tKnot = BSpline.knotPointsForDataPoints(t, K=4);
  spline = ConstrainedSpline(t, x, 4, tKnot);
  ```
 
                  
