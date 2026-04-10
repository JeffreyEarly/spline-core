---
layout: default
title: ConstrainedSpline
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 1
mathjax: true
---

#  ConstrainedSpline

Create a constrained spline from canonical solved state.


---

## Declaration
```matlab
 self = ConstrainedSpline(options)
```
## Parameters
+ `options.S`  spline degree scalar or vector with one entry per dimension
+ `options.knotAxes`  ordered knot-axis objects defining the spline basis
+ `options.xi`  fitted coefficient vector or array
+ `options.gridAxes`  ordered fit-grid axis objects
+ `options.distribution`  error model used during the fit
+ `options.dataPoints`  observation locations as an N-by-D point matrix
+ `options.dataValues`  observation values as an N-by-1 vector
+ `options.pointConstraints`  optional PointConstraint array used during fitting
+ `options.globalConstraints`  optional GlobalConstraint array used during fitting
+ `options.xMean`  optional additive output offset
+ `options.xStd`  optional multiplicative output scale

## Returns
+ `self`  ConstrainedSpline instance

## Discussion

  Use this low-level constructor when you already have the
  solved spline coefficients, fit grid, observations, and
  semantic constraints. For ordinary fitting from gridded data,
  use `ConstrainedSpline.fromGriddedValues(...)`.


