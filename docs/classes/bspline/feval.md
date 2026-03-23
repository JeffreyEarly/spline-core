---
layout: default
title: feval
parent: BSpline
grand_parent: Classes
nav_order: 10
mathjax: true
---

#  feval

Evaluate a B-spline at the supplied points.


---

## Declaration
```matlab
 values = feval(spline,t,options)
```
## Parameters
+ `spline`  BSpline instance
+ `t`  evaluation points
+ `options.D`  derivative order to evaluate

## Returns
+ `values`  spline values with the same shape as the query input

## Discussion

  This is a thin wrapper around `valueAtPoints(...)`.

  ```matlab
  values = feval(spline, tQuery);
  ```
