---
layout: default
title: xStd
parent: BSpline
grand_parent: Classes
nav_order: 29
mathjax: true
---

#  xStd

Multiplicative scale applied to spline evaluations.


---

## Type
+ Class: `double`
+ Size: `(1,1)`

## Description
Real valued property with no dimensions and no units.

## Discussion

  `xStd` is the multiplicative scaling in

  $$
  f(t) = x_{\mathrm{Mean}} + x_{\mathrm{Std}} \sum_{j=1}^{M} \xi_j B_{j,S}(t;\tau).
  $$

  It exists for the same numerical reason as
  [`xMean`](/spline-core/classes/bspline/xmean.html): when the output
  amplitude is large or very small, solving for a normalized
  coefficient vector `xi` is often better conditioned than solving
  directly in physical units. Unlike `xMean`, `xStd` multiplies both
  the spline values and all derivatives.

  ```matlab
  spline = BSpline(S=3, knotPoints=knotPoints, xi=xi, xMean=12.4, xStd=0.8);
  d2values = spline.valueAtPoints(tQuery, D=2);
  ```


