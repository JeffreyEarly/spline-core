---
layout: default
title: t_pp
parent: BSpline
grand_parent: Classes
nav_order: 24
mathjax: true
---

#  t_pp

Piecewise-polynomial breakpoint locations.

> Developer documentation: this item describes internal implementation details.


---

## Discussion

  These are the breakpoints of the cached interval representation.
  If `Nk = numel(knotPoints)`, then

  $$
  t_{\mathrm{pp}} = \tau_{K:(N_k-K+1)}.
  $$

  On interval `i`, the PP cache works in the local coordinate
  `u = t - t_pp(i)` for `t \in [t_pp(i), t_pp(i+1)]`.
  The functions
  [`ppCoefficientsFromSplineCoefficients`](/spline-core/classes/bspline/ppcoefficientsfromsplinecoefficients.html)
  and [`evaluateFromPPCoefficients`](/spline-core/classes/bspline/evaluatefromppcoefficients.html)
  are the main consumers of this breakpoint vector.

  ```matlab
  [C, tpp] = BSpline.ppCoefficientsFromSplineCoefficients( ...
      xi=spline.xi, knotPoints=spline.knotPoints, S=spline.S);
  values = BSpline.evaluateFromPPCoefficients( ...
      queryPoints=tQuery, C=C, tpp=tpp);
  ```

      size(t_pp) = length(knotPoints) - 2*K + 1
