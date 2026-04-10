---
layout: default
title: K
parent: TensorSpline
grand_parent: Classes
nav_order: 1
mathjax: true
---

#  K

Spline order in each tensor dimension.


---

## Discussion

  `K(k)` is the spline order along tensor dimension `k`. On each
  fixed tensor cell, the spline is a polynomial of degree
  `K(k)-1` in coordinate `x_k`, so `K=[4 4]` means a bicubic
  tensor spline and `K=[2 3 4]` means linear, quadratic, and cubic
  behavior across the three coordinates.

  The matching degree vector is
  [`S`](/spline-core/classes/tensorspline/s.html), with
  `S = K - 1`.

  ```matlab
  spline = TensorSpline.fromKnotPoints(knotPoints, xi, S=[3 3]);
  spline.K
  % returns [4 4]
  ```


