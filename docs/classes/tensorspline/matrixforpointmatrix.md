---
layout: default
title: matrixForPointMatrix
parent: TensorSpline
grand_parent: Classes
nav_order: 10
mathjax: true
---

#  matrixForPointMatrix

Evaluate the tensor-product basis matrix and optional derivatives.


---

## Declaration
```matlab
 B = matrixForPointMatrix(pointMatrix, options)
```
## Parameters
+ `pointMatrix`  query locations as a point matrix
+ `options.knotPoints`  knot vector in 1-D or cell array of knot vectors
+ `options.S`  spline degree scalar or vector with one entry per dimension
+ `options.D`  derivative order per dimension

## Returns
+ `B`  basis matrix with one row per query point

## Discussion

  Use this to assemble a tensor-product design matrix for
  interpolation, regression, or basis inspection.

  If `pointMatrix` has rows `x_i`, then row `i` of the returned matrix is the
  Kronecker product of the one-dimensional basis rows evaluated at `x_i`.
  In other words,

  $$
  \mathbf{B}_{i,:} =
  B^{(1)}(x_{i,1}) \otimes \cdots \otimes B^{(d)}(x_{i,d}),
  $$

  where each factor is the one-dimensional basis row in one coordinate
  direction, optionally replaced by its derivative row.

  ```matlab
  [Xq, Yq] = ndgrid(xq, yq);
  B = TensorSpline.matrixForPointMatrix([Xq(:), Yq(:)], knotPoints=knotPoints, S=[3 3]);
  values = B * spline.xi(:);
  ```


