---
layout: default
title: C
parent: BSpline
grand_parent: Classes
nav_order: 2
mathjax: true
---

#  C

Piecewise-polynomial coefficients for interval evaluation.

> Developer documentation: this item describes internal implementation details.


---

## Discussion

  For interval `i`, let `u = t - t_pp(i)`. The cached PP form stores

  $$
  f_i(u) = \sum_{m=0}^{S} \frac{c_{i,m}}{m!} u^m,
  $$

  where row `i` of `C` contains the coefficients in descending power
  order so they can be passed to `polyval` after factorial scaling.
  The helper
  [`ppCoefficientsFromSplineCoefficients`](/spline-core/classes/bspline/ppcoefficientsfromsplinecoefficients.html)
  builds `C`, and
  [`evaluateFromPPCoefficients`](/spline-core/classes/bspline/evaluatefromppcoefficients.html)
  evaluates it.

  ```matlab
  [C, tpp] = BSpline.ppCoefficientsFromSplineCoefficients( ...
      xi=spline.xi, knotPoints=spline.knotPoints, S=spline.S);
  xq = BSpline.evaluateFromPPCoefficients(queryPoints=tQuery, C=C, tpp=tpp);
  ```

      size(C) = [length(t_pp)-1, K]
