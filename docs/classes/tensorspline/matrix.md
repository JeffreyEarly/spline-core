---
layout: default
title: matrix
parent: TensorSpline
grand_parent: Classes
nav_order: 10
mathjax: true
---

#  matrix

Evaluate the tensor-product basis matrix and optional derivatives.


---

## Declaration
```matlab
 B = matrix(X,tKnot,K,options)
```
## Parameters
+ `X`  query locations as a point matrix
+ `tKnot`  cell array of knot vectors
+ `K`  spline order scalar or vector with one entry per dimension
+ `options.D`  derivative order per dimension

## Returns
+ `B`  basis matrix with one row per query point

## Discussion

  Use this to assemble a tensor-product design matrix for
  interpolation, regression, or basis inspection.

  ```matlab
  [Xq, Yq] = ndgrid(xq, yq);
  B = TensorSpline.matrix([Xq(:), Yq(:)], tKnot, [4 4]);
  values = B * spline.xi(:);
  ```


