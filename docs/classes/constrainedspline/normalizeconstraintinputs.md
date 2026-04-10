---
layout: default
title: normalizeConstraintInputs
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 16
mathjax: true
---

#  normalizeConstraintInputs

Split typed constraint inputs into point and global arrays.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 [pointConstraints,globalConstraints] = normalizeConstraintInputs(constraints,numDimensions)
```
## Parameters
+ `constraints`  mixed SplineConstraint array
+ `numDimensions`  target spline dimensionality

## Returns
+ `pointConstraints`  PointConstraint array
+ `globalConstraints`  GlobalConstraint array

## Discussion

  This helper partitions a mixed `SplineConstraint` array into its
  `PointConstraint` and `GlobalConstraint` components and checks that each
  constraint is dimensionally compatible with the target spline.


