---
layout: default
title: MinimumConstraintPoints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 5
mathjax: true
---

#  MinimumConstraintPoints

Return a minimal set of locations for universal derivative constraints.


---

## Declaration
```matlab
 tc = MinimumConstraintPoints(tKnot,K,T)
```
## Parameters
+ `tKnot`  knot sequence
+ `K`  spline order
+ `T`  constrained polynomial degree

## Returns
+ `tc`  constraint locations

## Discussion

  For a terminated spline of order K, this chooses the smallest
  set of points needed to constrain all segments at polynomial
  degree T.
 
  Use this helper to choose the smallest set of constraint
  locations needed to control a terminated spline at degree `T`.
 
  ```matlab
  tc = ConstrainedSpline.MinimumConstraintPoints(tKnot, 4, 0);
  ```
 
            
