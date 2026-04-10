---
layout: default
title: fromGriddedValues
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 9
mathjax: true
---

#  fromGriddedValues

Create a constrained spline fit from values on a rectilinear grid.


---

## Declaration
```matlab
 self = fromGriddedValues(gridVectors,values,options)
```
## Parameters
+ `gridVectors`  numeric vector in 1-D or cell array of grid vectors in higher dimensions
+ `values`  array of observation values on the supplied grid
+ `options.S`  spline degree scalar or vector with one entry per dimension
+ `options.knotPoints`  optional knot vector in 1-D or cell array of knot vectors
+ `options.splineDOF`  optional target number of splines per dimension
+ `options.distribution`  optional error model object for the fit
+ `options.constraints`  optional mixed SplineConstraint array

## Returns
+ `self`  ConstrainedSpline instance

## Discussion

  Use this factory for fitting from rectilinear-grid samples,
  especially in two or more dimensions. In one dimension,
  prefer `ConstrainedSpline.fromData(...)`. This method
  validates the gridded input, chooses the knot sequence,
  normalizes the constraint objects, solves the fit system, and
  then delegates to the cheap solved-state constructor.


