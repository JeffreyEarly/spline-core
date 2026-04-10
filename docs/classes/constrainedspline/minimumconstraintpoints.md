---
layout: default
title: minimumConstraintPoints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 14
mathjax: true
---

#  minimumConstraintPoints

Return a minimal set of one-dimensional locations for universal derivative constraints.


---

## Declaration
```matlab
 tc = minimumConstraintPoints(knotPoints, S, T)
```
## Parameters
+ `knotPoints`  one-dimensional knot sequence
+ `S`  spline degree
+ `T`  constrained polynomial degree

## Returns
+ `tc`  one-dimensional constraint locations

## Discussion

  For a terminated spline of order K, this chooses the smallest
  set of 1-D points needed to constrain all segments at
  polynomial degree T.

  If `D = S - T`, the returned locations provide enough one-dimensional
  sample points to constrain every piecewise-polynomial segment through
  derivative order `T` without oversampling all knots.

  ```matlab
  tc = ConstrainedSpline.minimumConstraintPoints(knotPoints, 3, 0);
  ```


