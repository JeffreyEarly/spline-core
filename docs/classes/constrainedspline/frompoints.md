---
layout: default
title: fromPoints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 11
mathjax: true
---

#  fromPoints

Create a tensor-product spline fit from scattered point observations.


---

## Declaration
```matlab
 self = fromPoints(points,values,options)
```
## Parameters
+ `points`  numeric vector in 1-D or point matrix in higher dimensions
+ `values`  observation values
+ `options.K`  optional spline order scalar or vector with one entry per dimension
+ `options.S`  optional spline degree scalar or vector with one entry per dimension
+ `options.tKnot`  optional knot vector in 1-D or cell array of knot vectors
+ `options.splineDOF`  optional target number of splines per dimension
+ `options.distribution`  optional error model object for the fit
+ `options.constraints`  optional mixed SplineConstraint array

## Returns
+ `self`  ConstrainedSpline instance

## Discussion

  Use this entry point for scattered observations represented
  as one point per row.

  ```matlab
  fit = ConstrainedSpline.fromPoints([x(:), y(:)], values, K=[4 4]);
  valuesFit = fit.evaluatePoints(queryPoints);
  ```


