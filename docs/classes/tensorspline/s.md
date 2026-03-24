---
layout: default
title: S
parent: TensorSpline
grand_parent: Classes
nav_order: 2
mathjax: true
---

#  S

Polynomial degree in each tensor dimension.


---

## Discussion

  `S(k)` is the polynomial degree along tensor dimension `k`. So
  `S=[1 1]` gives bilinear pieces, `S=[3 3]` gives bicubic pieces,
  and mixed values such as `S=[1 3]` are allowed when different
  coordinates need different smoothness or complexity.

  The matching order vector is
  [`K`](/spline-core/classes/tensorspline/k.html), with `K = S + 1`.


