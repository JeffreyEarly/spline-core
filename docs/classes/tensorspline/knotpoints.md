---
layout: default
title: knotPoints
parent: TensorSpline
grand_parent: Classes
nav_order: 9
mathjax: true
---

#  knotPoints

Knot vectors defining the spline basis.


---

## Discussion

  Returns a numeric vector in 1-D and a cell array in higher dimensions.

  These are the per-dimension knot vectors
  `\tau_1, \ldots, \tau_d` that define the separable basis
  functions `B_{j_k,S_k}(x_k;\tau_k)`.

  ```matlab
  spline.knotPoints
  % one vector in 1-D, one cell entry per dimension otherwise
  ```


