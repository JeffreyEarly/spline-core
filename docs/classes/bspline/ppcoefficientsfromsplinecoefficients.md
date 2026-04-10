---
layout: default
title: ppCoefficientsFromSplineCoefficients
parent: BSpline
grand_parent: Classes
nav_order: 20
mathjax: true
---

#  ppCoefficientsFromSplineCoefficients

Convert spline coefficients into piecewise-polynomial interval coefficients.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 [C,tpp,Xtpp] = ppCoefficientsFromSplineCoefficients(options)
```
## Parameters
+ `options.xi`  spline coefficients
+ `options.knotPoints`  spline knot points
+ `options.S`  spline degree
+ `options.Xtpp`  (optional) splines at the points tpp

## Returns
+ `C`  polynomial coefficients to be used in polyval, size(C) = [length(tpp)-1, K]
+ `tpp`  piece-wise polynomial intervals, size(tpp) = numel(knotPoints) - 2*S - 1
+ `Xtpp`  splines at the points tpp

## Discussion

  This helper rewrites the spline as local Taylor data over each interval.
  If `u = t - tpp(i)` on interval `i`, the cached representation satisfies

  $$
  f_i(u) = \sum_{m=0}^{S} \frac{c_{i,m}}{m!} u^m,
  $$

  where the rows of `C` store the coefficients $$c_{i,m}$$ in the order
  expected by `polyval` after the factorial scaling used in
  `evaluateFromPPCoefficients`.

  ```matlab
  [C, tpp] = BSpline.ppCoefficientsFromSplineCoefficients(xi=xi, knotPoints=knotPoints, S=3);
  xq = BSpline.evaluateFromPPCoefficients(queryPoints=tQuery, C=C, tpp=tpp);
  ```


