---
layout: default
title: matrix
parent: BSpline
grand_parent: Classes
nav_order: 13
mathjax: true
---

#  matrix

Evaluate terminated B-spline basis functions and optional derivatives.


---

## Declaration
```matlab
 B = matrix(t, knotPoints, S, options)
```
## Parameters
+ `t`  points at which to evaluate the splines
+ `knotPoints`  spline knot points
+ `S`  spline degree
+ `options.D`  (optional) number of spline derivatives to return, max(D)=S

## Returns
+ `B`  array of size `numel(t) x M x (D+1)` where `M = numel(knotPoints) - S - 1`

## Discussion

  Use this to assemble a design matrix for interpolation, regression, or
  direct inspection of the basis functions.

  For `D=0`, the returned matrix satisfies

  $$
  B_{ij} = B_{j,S}(t_i;\tau), \qquad x(t_i) \approx \sum_{j=1}^{M} B_{ij}\,\xi_j.
  $$

  When `D > 0`, slice `B(:,:,d+1)` stores the basis values for derivative
  order `d`, so `B(:,:,d+1) * xi` evaluates the `d`th derivative at `t`.

  ```matlab
  B = BSpline.matrix(t, knotPoints, 3);
  xi = B \ x;
  spline = BSpline(S=3, knotPoints=knotPoints, xi=xi);
  ```


