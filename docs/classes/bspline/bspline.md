---
layout: default
title: BSpline
parent: BSpline
grand_parent: Classes
nav_order: 1
mathjax: true
---

#  BSpline

Create a new B-spline representation from order, knots, and coefficients.


---

## Declaration
```matlab
 spline = BSpline(K,tKnot,xi)
```
## Parameters
+ `K`  spline order (degree S=K-1)
+ `tKnot`  knot points
+ `xi`  (optional) spline coefficients
+ `options.Xtpp`  optional cached basis values at piecewise breakpoints
+ `options.xMean`  optional additive output offset
+ `options.xStd`  optional multiplicative output scale

## Returns
+ `spline`  BSpline instance

## Discussion

  Optionally accepts cached breakpoint evaluations and affine
  output normalization parameters used by derived spline classes.
 
                  
