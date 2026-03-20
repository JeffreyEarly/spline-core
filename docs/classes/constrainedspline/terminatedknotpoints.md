---
layout: default
title: terminatedKnotPoints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 14
mathjax: true
---

#  terminatedKnotPoints

Ensure the knot vector has K repeated knots at each boundary.


---

## Declaration
```matlab
 tKnot = terminatedKnotPoints(tKnot,K)
```
## Parameters
+ `tKnot`  knot sequence
+ `K`  spline order

## Returns
+ `tKnot`  terminated knot sequence

## Discussion

  Use this helper to make sure a knot vector is fully
  terminated before fitting or evaluation.
 
  ```matlab
  tKnot = ConstrainedSpline.terminatedKnotPoints(tKnot, 4);
  ```
 
          
