---
layout: default
title: fromGriddedValues
parent: InterpolatingSpline
grand_parent: Classes
nav_order: 2
mathjax: true
---

#  fromGriddedValues

Create an interpolating spline from values on a rectilinear grid.


---

## Declaration
```matlab
 self = fromGriddedValues(gridVectors,values,options)
```
## Parameters
+ `gridVectors`  numeric vector in 1-D or cell array of grid vectors in higher dimensions
+ `values`  array of sampled values on the supplied grid
+ `options.S`  spline degree scalar or vector with one entry per dimension

## Returns
+ `self`  InterpolatingSpline instance

## Discussion

  Use this factory for ordinary interpolation from gridded
  samples. It validates the gridded input, builds the knot
  sequence, normalizes the values, solves for the interpolation
  coefficients, and then delegates to the cheap constructor.


