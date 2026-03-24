---
layout: default
title: basisSize
parent: TensorSpline
grand_parent: Classes
nav_order: 4
mathjax: true
---

#  basisSize

Number of basis functions in each dimension.


---

## Discussion

  If tensor dimension `k` has knot vector `tau_k` and order `K_k`,
  then the number of one-dimensional basis functions in that
  direction is

  $$
  M_k = \mathrm{numel}(\tau_k) - K_k.
  $$

  `basisSize` stores the row vector `[M_1 ... M_d]`. The total
  coefficient count is `prod(basisSize)`.


