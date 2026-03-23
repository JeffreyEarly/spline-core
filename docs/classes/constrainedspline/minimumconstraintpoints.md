---
layout: default
title: minimumConstraintPoints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 13
mathjax: true
---

#  minimumConstraintPoints

Return a minimal set of one-dimensional locations for universal derivative constraints.


---

## Declaration
```matlab
 tc = minimumConstraintPoints(tKnot,K,T)
```
## Parameters
+ `tKnot`  one-dimensional knot sequence
+ `K`  spline order
+ `T`  constrained polynomial degree

## Returns
+ `tc`  one-dimensional constraint locations

## Discussion

  For a terminated spline of order K, this chooses the smallest
  set of 1-D points needed to constrain all segments at
  polynomial degree T.

  ```matlab
  tc = ConstrainedSpline.minimumConstraintPoints(tKnot, 4, 0);
  ```


