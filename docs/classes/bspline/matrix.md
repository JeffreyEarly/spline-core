---
layout: default
title: matrix
parent: BSpline
grand_parent: Classes
nav_order: 12
mathjax: true
---

#  matrix

Evaluate terminated B-spline basis functions and optional derivatives.


---

## Declaration
```matlab
 B = matrix( t, tKnot, K, options )
```
## Parameters
+ `t`  points at which to evaluate the splines
+ `tKnot`  spline knot points
+ `K`  spline order (degree S=K-1)
+ `options.D`  (optional) number of spline derivatives to return, max(D)=K-1

## Returns
+ `B`  [numel(t) M D] where M = numel(tKnot)-K

## Discussion

  Returns the basis splines of order K evaluated at point t,
  given knot points tKnot. If you optionally provide D,
  then D derivatives will be returned.
 
              
