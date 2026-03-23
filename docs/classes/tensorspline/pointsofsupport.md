---
layout: default
title: pointsOfSupport
parent: TensorSpline
grand_parent: Classes
nav_order: 14
mathjax: true
---

#  pointsOfSupport

Return representative support points for a tensor-product spline basis.


---

## Declaration
```matlab
 [pointMatrix,supportVectors] = pointsOfSupport(tKnot,K,D)
```
## Parameters
+ `tKnot`  cell array of knot vectors
+ `K`  spline order scalar or vector with one entry per dimension
+ `D`  reserved derivative-order argument for API compatibility

## Returns
+ `pointMatrix`  matrix with one row per tensor support point
+ `supportVectors`  cell array with one support vector per dimension

## Discussion

  Use these points when you need one representative location per tensor
  basis function, for example when constructing transformed splines from
  sampled values.

  ```matlab
  [supportPoints, supportVectors] = TensorSpline.pointsOfSupport(tKnot, [4 4]);
  values = spline(supportPoints);
  ```


