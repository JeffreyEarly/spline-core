---
layout: default
title: feval
parent: TensorSpline
grand_parent: Classes
nav_order: 8
mathjax: true
---

#  feval

Evaluate a tensor spline at the supplied points.


---

## Declaration
```matlab
 values = feval(spline,varargin)
```
## Parameters
+ `spline`  TensorSpline instance
+ `varargin`  query locations and optional derivative orders

## Returns
+ `values`  spline values with the same shape as the query input

## Discussion

  This is equivalent to `spline(...)` and is useful when you prefer an
  explicit function-call form.

  ```matlab
  values = feval(spline, xq, yq);
  ```


