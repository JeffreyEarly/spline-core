---
layout: default
title: ConstrainedSpline
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 4
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

                  
