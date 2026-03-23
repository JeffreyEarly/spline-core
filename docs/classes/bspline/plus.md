---
layout: default
title: plus
parent: BSpline
grand_parent: Classes
nav_order: 14
mathjax: true
---

#  plus

Add a scalar offset to a spline output.


---

## Declaration
```matlab
 f = plus(f,g)
```
## Parameters
+ `f`  BSpline instance or scalar
+ `g`  scalar or BSpline instance

## Returns
+ `f`  transformed BSpline or empty when adding []

## Discussion

  This shifts the spline output without changing the knot sequence or
  spline coefficients.

  ```matlab
  shiftedSpline = spline + 3;
  ```


