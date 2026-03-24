---
layout: default
title: S
parent: BSpline
grand_parent: Classes
nav_order: 4
mathjax: true
---

#  S

Polynomial degree S = K - 1.


---

## Discussion

  The degree is the highest power that appears in each local
  polynomial piece:

  $$
  p_i(t) = a_{i,0} + a_{i,1}(t-t_i) + \cdots + a_{i,S}(t-t_i)^S.
  $$

  Degree `S=0` is piecewise constant, `S=1` is piecewise linear,
  `S=2` is quadratic, and `S=3` is cubic. The matching order is
  [`K`](/spline-core/classes/bspline/k.html), with `K = S + 1`.

  ```matlab
  spline = BSpline(S=3, knotPoints=knotPoints, xi=xi);
  spline.S
  % returns 3 for a cubic spline
  ```

    A cubic spline is K=4, S=3
