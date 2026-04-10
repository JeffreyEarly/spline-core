---
layout: default
title: fromData
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 8
mathjax: true
---

#  fromData

Create a constrained spline fit from one-dimensional samples.


---

## Declaration
```matlab
 self = fromData(t,x,options)
```
## Parameters
+ `t`  one-dimensional sample locations
+ `x`  observation values sampled at `t`
+ `options.S`  spline degree
+ `options.knotPoints`  optional one-dimensional knot vector
+ `options.splineDOF`  optional target number of splines
+ `options.distribution`  optional error model object for the fit
+ `options.constraints`  optional mixed SplineConstraint array

## Returns
+ `self`  ConstrainedSpline instance

## Discussion

  Use this factory for ordinary one-dimensional noisy-data
  fitting. It validates the shared sample vectors, then
  delegates to the general rectilinear-grid factory so the
  one-dimensional behavior stays aligned with
  `ConstrainedSpline.fromGriddedValues(...)`.


