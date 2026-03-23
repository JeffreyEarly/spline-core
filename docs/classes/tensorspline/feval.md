---
layout: default
title: feval
parent: TensorSpline
grand_parent: Classes
nav_order: 8
mathjax: true
---

#  feval

Evaluate a tensor spline at matching-size query arrays.


---

## Declaration
```matlab
 values = feval(spline,X1,...,Xn,options)
```
## Parameters
+ `spline`  TensorSpline instance
+ `X1,...,Xn`  matching-size query locations as one array per dimension
+ `options.D`  derivative order per dimension

## Returns
+ `values`  spline values with the same shape as the query input

## Discussion

  This is a thin wrapper around `valueAtPoints(...)`. Paired
  column vectors give pointwise queries, while matching `ndgrid`
  arrays give gridded evaluation on a tensor-product lattice.

  ```matlab
  values = feval(spline, xq, yq);
  [Xq,Yq] = ndgrid(linspace(-1,1,40), linspace(0,2,50));
  F = feval(spline, Xq, Yq);
  ```


