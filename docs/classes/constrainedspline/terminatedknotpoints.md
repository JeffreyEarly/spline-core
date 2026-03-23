---
layout: default
title: terminatedKnotPoints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 17
mathjax: true
---

#  terminatedKnotPoints

Ensure each knot vector has K repeated knots at its boundaries.


---

## Declaration
```matlab
 tKnot = terminatedKnotPoints(tKnot,K)
```
## Parameters
+ `tKnot`  knot vector in 1-D or cell array of knot vectors
+ `K`  spline order scalar or vector with one entry per dimension

## Returns
+ `tKnot`  terminated knot sequence

## Discussion

  Use this helper when you want to terminate a manually supplied
  knot sequence before fitting. In 1-D it accepts a numeric knot
  vector; in higher dimensions it accepts a cell array with one
  knot vector per dimension.

  ```matlab
  tKnot = ConstrainedSpline.terminatedKnotPoints(tKnot, 4);
  ```


