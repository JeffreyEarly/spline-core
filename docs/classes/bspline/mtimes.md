---
layout: default
title: mtimes
parent: BSpline
grand_parent: Classes
nav_order: 16
mathjax: true
---

#  mtimes

Multiply a spline output by a scalar.


---

## Declaration
```matlab
 f = mtimes(f,g)
```
## Parameters
+ `f`  BSpline instance or scalar
+ `g`  scalar or BSpline instance

## Returns
+ `f`  transformed BSpline or empty when multiplying by []

## Discussion

  This rescales the spline output without refitting the spline
  coefficients.

  ```matlab
  scaledSpline = 2.5 * spline;
  ```


