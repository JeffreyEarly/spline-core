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
 f = evaluateFromPPCoefficients(options)
```
## Parameters
+ `options.queryPoints`  points at which to evaluate the splines
+ `options.C`  polynomial coefficients to be used in polyval, size(C) = [length(tpp)-1, K]
+ `options.tpp`  piece-wise polynomial intervals
+ `options.D`  number of derivatives

## Returns
+ `f`  array the same size as queryPoints

## Discussion

  On interval `i`, let `u = queryPoints - tpp(i)`. This function evaluates

  $$
  f_i^{(D)}(u) = \sum_{m=D}^{S} \frac{c_{i,m}}{(m-D)!} u^{m-D},
  $$

  where the interval coefficients $$c_{i,m}$$ are stored in `C`.

  ```matlab
  xq = BSpline.evaluateFromPPCoefficients(queryPoints=tQuery, C=C, tpp=tpp);
  dxq = BSpline.evaluateFromPPCoefficients(queryPoints=tQuery, C=C, tpp=tpp, D=1);
  ```


