---
layout: default
title: BSpline
parent: BSpline
grand_parent: Classes
nav_order: 1
mathjax: true
---

#  BSpline

Create a one-dimensional spline from degree, knots, and coefficients.


---

## Declaration
```matlab
 spline = BSpline(options)
```
## Parameters
+ `options.S`  spline degree
+ `options.knotPoints`  knot points
+ `options.xi`  (optional) spline coefficients
+ `options.Xtpp`  optional cached basis values at piecewise breakpoints
+ `options.xMean`  optional additive output offset
+ `options.xStd`  optional multiplicative output scale

## Returns
+ `spline`  BSpline instance

## Discussion

  Use this constructor when you already know the terminated knot
  sequence `knotPoints` and the coefficient vector `xi`.

  The constructed spline is

  $$
  f(t) = x_{\mathrm{Mean}} + x_{\mathrm{Std}} \sum_{j=1}^{M} \xi_j B_{j,S}(t;\tau).
  $$

  ```matlab
  knotPoints = [0; 0; 0; 0; 1; 1; 1; 1];
  xi = [1; -0.5; 0.25; 0];
  spline = BSpline(S=3, knotPoints=knotPoints, xi=xi);
  x = spline(linspace(0,1,50)');
  ```


