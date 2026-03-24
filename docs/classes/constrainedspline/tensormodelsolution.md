---
layout: default
title: tensorModelSolution
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 16
mathjax: true
---

#  tensorModelSolution

Solve the tensor noisy-data model with iteratively reweighted least squares.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 [xi,CmInv,W] = tensorModelSolution(values,designMatrix,distribution,rho_X,Aeq,beq,Aineq,bineq)
```
## Parameters
+ `values`  observation values as an N-by-1 vector
+ `designMatrix`  splines on the observation grid, N-by-M
+ `distribution`  distribution describing the errors
+ `rho_X`  optional observation correlation matrix
+ `Aeq`  optional equality-constraint matrix
+ `beq`  optional equality-constraint values
+ `Aineq`  optional inequality-constraint matrix
+ `bineq`  optional inequality-constraint values

## Returns
+ `xi`  fitted tensor spline coefficients
+ `CmInv`  inverse coefficient covariance or system matrix
+ `W`  final weight matrix or weights

## Discussion

  This is the core fitting loop behind
  [`ConstrainedSpline`](/spline-core/classes/constrainedspline/constrainedspline.html).
  At each iteration it solves

  $$
  \min_{\xi}\ (y - \mathbf{B}\xi)^{T} W^{(n)} (y - \mathbf{B}\xi)
  $$

  subject to the supplied equality and inequality constraints, then updates
  the per-observation variances from the current residuals
  $$r^{(n)} = y - \mathbf{B}\xi^{(n)}$$ through the distribution model.

  When `rho_X` is supplied, the observation covariance is modeled as

  $$
  \Sigma^{(n)}_{ij} = \sigma_i^{(n)} \rho_{ij} \sigma_j^{(n)},
  $$

  and `W` represents the corresponding weighted solve rather than an
  explicitly formed inverse matrix.


