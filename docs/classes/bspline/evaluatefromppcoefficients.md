---
layout: default
title: evaluateFromPPCoefficients
parent: BSpline
grand_parent: Classes
nav_order: 9
mathjax: true
---

#  evaluateFromPPCoefficients

Evaluate a cached piecewise-polynomial spline representation.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 f = evaluateFromPPCoefficients(t,C,tpp, D)
```
## Parameters
+ `t`  points at which to evaluate the splines
+ `C`  polynomial coefficients to be used in polyval, size(C) = [length(tpp)-1, K]
+ `tpp`  piece-wise polynomial intervals
+ `D`  number of derivatives

## Returns
+ `f`  array the same size as t

## Discussion

  On interval `i`, let `u = t - tpp(i)`. This function evaluates

  $$
  f_i^{(D)}(u) = \sum_{m=D}^{S} \frac{c_{i,m}}{(m-D)!} u^{m-D},
  $$

  where the interval coefficients \(c_{i,m}\) are stored in `C`.

  ```matlab
  xq = BSpline.evaluateFromPPCoefficients(tQuery, C, tpp);
  dxq = BSpline.evaluateFromPPCoefficients(tQuery, C, tpp, 1);
  ```


