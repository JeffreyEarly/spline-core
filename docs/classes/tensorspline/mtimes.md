---
layout: default
title: mtimes
parent: TensorSpline
grand_parent: Classes
nav_order: 10
mathjax: true
---

#  mtimes

Multiply tensor-spline outputs by a scalar.


---

## Declaration
```matlab
 f = mtimes(f,g)
```
## Parameters
+ `f`  TensorSpline instance or scalar
+ `g`  scalar or TensorSpline instance

## Returns
+ `f`  transformed TensorSpline or empty when multiplying by []

## Discussion

  ```matlab
  scaledSpline = 2.5 * spline;
  ```
 
          
