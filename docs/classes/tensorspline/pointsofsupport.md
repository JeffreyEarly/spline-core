---
layout: default
title: pointsOfSupport
parent: TensorSpline
grand_parent: Classes
nav_order: 15
mathjax: true
---

#  pointsOfSupport

Return representative support points for a tensor-product spline basis.


---

## Declaration
```matlab
 [pointMatrix,supportVectors] = pointsOfSupport(knotPoints, S)
```
## Parameters
+ `knotPoints`  knot vector in 1-D or cell array of knot vectors
+ `S`  spline degree scalar or vector with one entry per dimension

## Returns
+ `pointMatrix`  matrix with one row per tensor support point
+ `supportVectors`  cell array with one support vector per dimension

## Discussion

  Use these points when you need one representative location per tensor
  basis function, for example when constructing transformed splines from
  sampled values.

  The support vectors are computed one dimension at a time with
  `BSpline.pointsOfSupport`, then combined by a Cartesian product to form
  the returned point matrix.

  ```matlab
  [supportPoints, supportVectors] = TensorSpline.pointsOfSupport(knotPoints, [3 3]);
  values = spline(supportVectors{:});
  ```


