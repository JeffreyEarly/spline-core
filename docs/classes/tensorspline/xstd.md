---
layout: default
title: xStd
parent: TensorSpline
grand_parent: Classes
nav_order: 22
mathjax: true
---

#  xStd

Multiplicative scale applied to evaluations.


---

## Discussion

  `xStd` is the multiplicative scale factor in

  $$
  f(x_1,\ldots,x_d) = x_{\mathrm{Mean}} + x_{\mathrm{Std}}
  \sum_{j_1,\ldots,j_d} \xi_{j_1,\ldots,j_d}
  \prod_{k=1}^{d} B_{j_k,S_k}(x_k;\tau_k).
  $$

  It is useful when the fitted field has large or very small
  amplitude: the stored coefficient array can remain close to order
  one while evaluations and derivatives are rescaled back to
  physical units.


