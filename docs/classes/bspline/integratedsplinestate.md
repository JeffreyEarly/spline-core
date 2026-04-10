---
layout: default
title: integratedSplineState
parent: BSpline
grand_parent: Classes
nav_order: 12
mathjax: true
---

#  integratedSplineState

Return the canonical spline state of the zero-anchored antiderivative.


---

## Declaration
```matlab
 [xiIntegrated,knotPointsIntegrated,SIntegrated] = integratedSplineState(xi, options)
```
## Parameters
+ `xi`  spline coefficient vector or matrix with one spline per column
+ `options.knotPoints`  terminated knot sequence for the input spline basis
+ `options.S`  spline degree of the input coefficients
+ `options.xMean`  optional additive output offset shared by every column
+ `options.xStd`  optional multiplicative output scale shared by every column

## Returns
+ `xiIntegrated`  antiderivative spline coefficient matrix with one extra row
+ `knotPointsIntegrated`  terminated knot sequence for the antiderivative spline
+ `SIntegrated`  spline degree of the antiderivative spline

## Discussion

  Use this expert utility when B-spline coefficients are already known and
  the exact antiderivative state should be computed without constructing a
  temporary `BSpline` object first.

  For coefficient matrix `xi`, each column is integrated independently
  with the shared affine output normalization

  $$
  f(t) = x_{\mathrm{Mean}} + x_{\mathrm{Std}} \sum_{j=1}^{M} \xi_j B_{j,S}(t;\tau),
  $$

  producing the canonical antiderivative spline state

  $$
  F(t) = \int_{\tau_1}^{t} f(s)\,ds.
  $$

  ```matlab
  [xiInt, knotPointsInt, SInt] = BSpline.integratedSplineState( ...
      xi, knotPoints=knotPoints, S=3);
  intspline = BSpline(S=SInt, knotPoints=knotPointsInt, xi=xiInt);
  ```


