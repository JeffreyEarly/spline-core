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
 
  Use this constructor when you already have a knot sequence and
  coefficient vector and want a spline object for evaluation or
  algebraic manipulation.
 
  ```matlab
  tKnot = [0; 0; 0; 0; 1; 1; 1; 1];
  xi = [1; -0.5; 0.25; 0];
  spline = BSpline(4, tKnot, xi);
  x = spline(linspace(0,1,50)');
  ```
 
                  
