---
layout: default
title: ConstrainedSpline
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 4
mathjax: true
---

#  ConstrainedSpline

Create a tensor-product spline fit to noisy observations.


---

## Declaration
```matlab
 self = ConstrainedSpline(points,values,options)
```
## Parameters
+ `points`  observation locations as a point matrix or cell array of matching grids
+ `values`  observation values
+ `options.K`  optional spline order scalar or vector with one entry per dimension
+ `options.S`  optional spline degree scalar or vector with one entry per dimension
+ `options.tKnot`  optional knot vector in 1-D or cell array of knot vectors
+ `options.dataDOF`  optional stride used to subsample sorted coordinates before knot placement
+ `options.splineDOF`  optional target number of splines per dimension
+ `options.distribution`  optional error model object for the fit
+ `options.constraints`  optional mixed SplineConstraint array

## Returns
+ `self`  ConstrainedSpline instance

## Discussion

  Use this constructor with an `N x D` point matrix or a cell
  array of matching grids when fitting noisy tensor-product
  data.

  In one dimension, `K=N` together with `splineDOF=N` gives the
  same least-squares polynomial fit as `polyfit(t,x,N-1)`.

  ```matlab
  spline = ConstrainedSpline(points, values, K=[4 4]);
  valuesFit = spline(points);
  ```


