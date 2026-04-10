---
layout: default
title: valueAtPoints
parent: BSpline
grand_parent: Classes
nav_order: 27
mathjax: true
---

#  valueAtPoints

Evaluate the spline or one of its derivatives at arbitrary points.


---

## Declaration
```matlab
 x_out = valueAtPoints(self,t,options)
```
## Parameters
+ `self`  BSpline instance
+ `t`  evaluation points
+ `options.D`  derivative order to evaluate

## Returns
+ `x_out`  array matching the shape of t

## Discussion

  This is the primary explicit evaluation method. Pass
  `D=0` for spline values, `D=1` for the first
  derivative, and so on.

  The returned array represents

  $$
  f^{(D)}(t) = x_{\mathrm{Std}} \sum_{j=1}^{M} \xi_j B_{j,S}^{(D)}(t;\tau),
  $$

  with `xMean` added back only when `D=0`.

  ```matlab
  x = spline.valueAtPoints(tQuery);
  d2x = spline.valueAtPoints(tQuery, D=2);
  ```


