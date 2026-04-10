---
layout: default
title: xi
parent: BSpline
grand_parent: Classes
nav_order: 30
mathjax: true
---

#  xi

Spline coefficients as an Mx1 vector.


---

## Discussion

  The coefficient vector weights the terminated B-spline basis in

  $$
  f(t) = x_{\mathrm{Mean}} + x_{\mathrm{Std}} \sum_{j=1}^{M} \xi_j B_{j,S}(t;\tau).
  $$

  So `xi(j)` is the weight on the `j`th basis function. The basis
  itself comes from
  [`matrixForDataPoints`](/spline-core/classes/bspline/matrixfordatapoints.html),
  and evaluation is handled by
  [`valueAtPoints`](/spline-core/classes/bspline/valueatpoints.html).
  For a knot sequence `tau` and order `K`, the coefficient count is
  `M = numel(knotPoints) - K`.

  ```matlab
  X = BSpline.matrixForDataPoints(t, knotPoints=knotPoints, S=3);
  xi = X \ x;
  spline = BSpline(S=3, knotPoints=knotPoints, xi=xi);
  ```


