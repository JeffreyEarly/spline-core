---
layout: default
title: plus
parent: TensorSpline
grand_parent: Classes
nav_order: 10
mathjax: true
---

#  plus

Add a scalar offset to tensor-spline outputs.


---

## Declaration
```matlab
 f = plus(f,g)
```
## Parameters
+ `f`  TensorSpline instance or scalar
+ `g`  scalar or TensorSpline instance

## Returns
+ `f`  transformed TensorSpline or empty when adding []

## Discussion

  ```matlab
  shiftedSpline = spline + 3;
  ```
 
          
