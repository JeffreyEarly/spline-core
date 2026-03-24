---
layout: default
title: K
parent: BSpline
grand_parent: Classes
nav_order: 3
mathjax: true
---

#  K

Spline order K, where polynomial degree is S = K - 1.


---

## Discussion

  The order is the number of coefficients in each local polynomial
  piece. On any one interval, a spline of order `K` is a polynomial
  of the form

  $$
  p_i(t) = a_{i,0} + a_{i,1}(t-t_i) + \cdots + a_{i,K-1}(t-t_i)^{K-1}.
  $$

  So `K=1` gives piecewise constants, `K=2` gives piecewise
  linear splines, and `K=4` gives cubic splines. The matching degree
  property is [`S`](/spline-core/classes/bspline/s.html), with
  `S = K - 1`.

  ```matlab
  spline = BSpline(S=3, knotPoints=knotPoints, xi=xi);
  spline.K
  % returns 4, meaning each piece is cubic
  ```


