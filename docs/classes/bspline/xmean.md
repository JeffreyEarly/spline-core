---
layout: default
title: xMean
parent: BSpline
grand_parent: Classes
nav_order: 28
mathjax: true
---

#  xMean

Mean added back to zero-order spline evaluations.


---

## Type
+ Class: `double`
+ Size: `(1,1)`

## Description
Real valued property with no dimensions and no units.

## Discussion

  `xMean` is an output offset used in the stored spline model

  $$
  f(t) = x_{\mathrm{Mean}} + x_{\mathrm{Std}} \sum_{j=1}^{M} \xi_j B_{j,S}(t;\tau).
  $$

  This affine output normalization is useful for numerical work:
  large means can be removed before solving for the coefficient
  vector, then added back only at evaluation time. That keeps the
  fitted coefficients closer to order one and reduces the need to
  represent a large constant level directly in `xi`.

  `xMean` contributes only to zero-order evaluation. Derivatives are
  unaffected because constants differentiate to zero.

  ```matlab
  spline = BSpline(S=3, knotPoints=knotPoints, xi=xi, xMean=12.4, xStd=0.8);
  values = spline(tQuery);
  ```


