---
layout: default
title: power
parent: BSpline
grand_parent: Classes
nav_order: 17
mathjax: true
---

#  power

Raise spline values to a real scalar power by refitting support values.


---

## Declaration
```matlab
 poweredSpline = power(spline,exponent)
```
## Parameters
+ `spline`  BSpline instance
+ `exponent`  scalar exponent

## Returns
+ `poweredSpline`  BSpline approximating spline.^exponent

## Discussion

  This is useful for simple nonlinear transforms of a spline when an exact
  spline-space representation is not available.

  The implementation samples the spline at representative support points,
  forms `values.^exponent`, and fits a new spline to those transformed
  samples. When the transformed samples are nonnegative up to tolerance, it
  uses a positive constrained fit; otherwise it uses an unconstrained fit.

  ```matlab
  squaredSpline = spline.^2;
  rootSpline = spline.^(1/2);
  ```


