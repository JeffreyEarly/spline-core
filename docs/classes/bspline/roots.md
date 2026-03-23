---
layout: default
title: roots
parent: BSpline
grand_parent: Classes
nav_order: 19
mathjax: true
---

#  roots

Return real roots of a spline within its domain.


---

## Declaration
```matlab
 values = roots(spline)
```
## Parameters
+ `spline`  BSpline instance

## Returns
+ `values`  sorted real roots in the spline domain

## Discussion

  Use this to locate zero crossings of the spline over its support.

  The implementation works interval by interval on the cached
  piecewise-polynomial coefficients, then keeps only real roots that lie in
  the corresponding interval.

  ```matlab
  tZero = roots(spline);
  ```


