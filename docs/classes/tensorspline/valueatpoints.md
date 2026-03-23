---
layout: default
title: valueAtPoints
parent: TensorSpline
grand_parent: Classes
nav_order: 20
mathjax: true
---

#  valueAtPoints

Evaluate the tensor spline or a mixed partial derivative.


---

## Declaration
```matlab
 values = valueAtPoints(self,X1,...,Xn,options)
```
## Parameters
+ `self`  TensorSpline instance
+ `X1,...,Xn`  matching-size query locations as one array per dimension
+ `options.D`  derivative order per dimension

## Returns
+ `values`  spline values reshaped to match the query input

## Discussion

  This is the primary explicit evaluation method. Supply one
  matching-size query array per tensor dimension. Paired column
  vectors give pointwise queries, while matching ndgrid arrays give
  gridded evaluation over a tensor-product lattice.

  For derivative order vector `D = [D_1 ... D_d]`, this evaluates

  $$
  \partial^{D} f(x_1,\ldots,x_d) =
  x_{\mathrm{Std}}
  \sum_{j_1,\ldots,j_d} \xi_{j_1,\ldots,j_d}
  \prod_{k=1}^{d} B_{j_k,S_k}^{(D_k)}(x_k;\tau_k),
  $$

  with `xMean` added back only when all entries of `D` are zero.

  ```matlab
  values = spline.valueAtPoints(xq, yq);
  dFdx = spline.valueAtPoints(xq, yq, D=[1 0]);
  [Xq,Yq] = ndgrid(linspace(-1,1,40), linspace(0,2,50));
  F = spline.valueAtPoints(Xq, Yq);
  ```


