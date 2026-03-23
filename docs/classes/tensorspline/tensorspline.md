---
layout: default
title: TensorSpline
parent: TensorSpline
grand_parent: Classes
nav_order: 3
mathjax: true
---

#  TensorSpline

Create a tensor-product spline from per-dimension degrees, knots, and coefficients.


---

## Declaration
```matlab
 self = TensorSpline(options)
```
## Parameters
+ `options.S`  spline degree scalar or vector with one entry per dimension
+ `options.knotPoints`  knot vector in 1-D or cell array of knot vectors
+ `xi`  optional tensor-product coefficient array or vector
+ `options.xMean`  optional additive output offset
+ `options.xStd`  optional multiplicative output scale

## Returns
+ `self`  TensorSpline instance

## Discussion

  Use this constructor when you already know the per-dimension
  knot vectors and tensor-product coefficients.

  The stored spline has the tensor-product form

  $$
  f(x_1,\ldots,x_d) = x_{\mathrm{Mean}} + x_{\mathrm{Std}}
  \sum_{j_1,\ldots,j_d} \xi_{j_1,\ldots,j_d}
  \prod_{k=1}^{d} B_{j_k,S_k}(x_k;\tau_k).
  $$

  ```matlab
  spline = TensorSpline(S=[3 3], knotPoints=knotPoints, xi=xi);
  [Xq,Yq] = ndgrid(linspace(0,1,40), linspace(0,1,40));
  values = spline(Xq, Yq);
  ```


