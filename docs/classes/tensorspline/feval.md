---
layout: default
title: feval
parent: TensorSpline
grand_parent: Classes
nav_order: 9
mathjax: true
---

#  feval

Evaluate a tensor spline at the supplied points.


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

  This is a thin wrapper around `valueAtPoints(...)`.

  ```matlab
  values = feval(spline, xq, yq);
  ```
