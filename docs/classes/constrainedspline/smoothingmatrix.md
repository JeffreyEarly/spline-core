---
layout: default
title: smoothingMatrix
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 9
mathjax: true
---

#  smoothingMatrix

Return the smoothing matrix that maps observations to fitted values.


---

## Declaration
```matlab
 S = smoothingMatrix(self)
```
## Parameters
+ `self`  ConstrainedSpline instance

## Returns
+ `S`  smoothing matrix

## Discussion

  Use this to inspect the linear action of the final weighted
  fit on the observed data.

  For an unconstrained fit with diagonal weights $$W$$, this matrix is the
  familiar linear smoother

  $$
  S = \mathbf{B}(\mathbf{B}^{T} W \mathbf{B})^{-1}\mathbf{B}^{T}W.
  $$

  When the fit uses a full observation covariance, the implementation uses
  the same linear map but applies the covariance through the stored solve
  object rather than explicitly forming an inverse.

  ```matlab
  S = spline.smoothingMatrix();
  valuesFit = S * spline.dataValues;
  ```


