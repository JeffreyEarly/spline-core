---
layout: default
title: weightMatrixFromSigma2
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 20
mathjax: true
---

#  weightMatrixFromSigma2

Build the observation-weight matrix from per-observation variances.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 W = weightMatrixFromSigma2(sigma2,rho_X)
```
## Parameters
+ `sigma2`  per-observation variances
+ `rho_X`  optional observation correlation matrix

## Returns
+ `W`  weight representation for the fit

## Discussion

  For independent errors this returns the diagonal weights

  $$
  W = \mathrm{diag}(\sigma_1^{-2},\ldots,\sigma_N^{-2}),
  $$

  represented here by the vector `1./sigma2`.

  With correlated errors, it builds the observation covariance

  $$
  \Sigma_{ij} = \sigma_i \rho_{ij} \sigma_j,
  $$

  and returns a MATLAB `decomposition` object for $$\Sigma$$, which is then
  used in left-division solves by
  [`weightedNormalEquations`](/spline-core/classes/constrainedspline/weightednormalequations.html).


