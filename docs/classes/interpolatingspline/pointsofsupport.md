---
layout: default
title: pointsOfSupport
parent: InterpolatingSpline
grand_parent: Classes
nav_order: 15
mathjax: true
---

#  pointsOfSupport

Return representative support points for a terminated spline basis.


---

## Declaration
```matlab
 t = pointsOfSupport(tKnot,K,D)
```
## Parameters
+ `tKnot`  knot sequence
+ `K`  spline order
+ `D`  reserved derivative-order argument for API compatibility

## Returns
+ `t`  support point locations

## Discussion

  This function assumes that the splines are terminated at the
  boundary with repeated end knots.
 
            
