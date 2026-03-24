---
layout: default
title: Xtpp
parent: BSpline
grand_parent: Classes
nav_order: 5
mathjax: true
---

#  Xtpp

Basis values and derivatives sampled at piecewise breakpoints.

> Developer documentation: this item describes internal implementation details.


---

## Discussion

  This cached array stores the basis and its derivatives evaluated at
  the piecewise-polynomial breakpoints [`t_pp`](/spline-core/classes/bspline/t_pp.html):

  $$
  \mathrm{Xtpp}(i,j,d+1) = B_{j,S}^{(d)}(t_{\mathrm{pp},i};\tau).
  $$

  [`ppCoefficientsFromSplineCoefficients`](/spline-core/classes/bspline/ppcoefficientsfromsplinecoefficients.html)
  uses `Xtpp` to convert the spline coefficients `xi` into the cached
  interval coefficients [`C`](/spline-core/classes/bspline/c.html),
  and [`evaluateFromPPCoefficients`](/spline-core/classes/bspline/evaluatefromppcoefficients.html)
  consumes the resulting PP representation for fast evaluation.

  ```matlab
  [C, tpp, Xtpp] = BSpline.ppCoefficientsFromSplineCoefficients( ...
      xi=spline.xi, knotPoints=spline.knotPoints, S=spline.S);
  size(Xtpp)
  % numel(tpp) x numel(xi) x (S+1)
  ```


