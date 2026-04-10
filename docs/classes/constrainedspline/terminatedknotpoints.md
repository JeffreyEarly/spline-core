---
layout: default
title: terminatedKnotPoints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 20
mathjax: true
---

#  terminatedKnotPoints

Ensure each knot vector has S+1 repeated knots at its boundaries.


---

## Declaration
```matlab
 knotPoints = terminatedKnotPoints(knotPoints, S)
```
## Parameters
+ `knotPoints`  knot vector in 1-D or cell array of knot vectors
+ `S`  spline degree scalar or vector with one entry per dimension

## Returns
+ `knotPoints`  terminated knot sequence

## Discussion

  Use this helper when you want to terminate a manually supplied
  knot sequence before fitting. In 1-D it accepts a numeric knot
  vector; in higher dimensions it accepts a cell array with one
  knot vector per dimension.

  This operation increases the multiplicity of the first and last knot
  values to `S+1`, which makes the spline basis terminate at the grid
  endpoints.

  ```matlab
  knotPoints = ConstrainedSpline.terminatedKnotPoints(knotPoints, 3);
  ```


