---
layout: default
title: InterpolatingSpline
parent: InterpolatingSpline
grand_parent: Classes
nav_order: 1
mathjax: true
---

#  InterpolatingSpline

Create an interpolating spline from canonical solved state.


---

## Declaration
```matlab
 self = InterpolatingSpline(options)
```
## Parameters
+ `options.S`  spline degree scalar or vector with one entry per dimension
+ `options.knotAxes`  ordered knot-axis objects defining the spline basis
+ `options.xi`  interpolating coefficient vector or array
+ `options.gridAxes`  ordered interpolation-grid axis objects
+ `options.xMean`  optional additive output offset
+ `options.xStd`  optional multiplicative output scale

## Returns
+ `self`  InterpolatingSpline instance

## Discussion

  Use this low-level constructor when you already have the
  interpolation knot axes, coefficient state, and grid axes.
  For ordinary interpolation from gridded samples, use
  `InterpolatingSpline.fromGriddedValues(...)`.

  ```matlab
  spline = InterpolatingSpline( ...
      S=[3 3], ...
      knotAxes=SplineAxis.arrayFromVectors(knotPoints), ...
      xi=xi, ...
      gridAxes=SplineAxis.arrayFromVectors({x, y}));
  ```


