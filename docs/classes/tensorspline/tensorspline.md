---
layout: default
title: TensorSpline
parent: TensorSpline
grand_parent: Classes
nav_order: 3
mathjax: true
---

#  TensorSpline

Create a tensor-product spline from per-dimension orders, knots, and coefficients.


---

## Declaration
```matlab
 self = TensorSpline(K,tKnot,xi,options)
```
## Parameters
+ `K`  spline order scalar or vector with one entry per dimension
+ `tKnot`  cell array of knot vectors
+ `xi`  optional tensor-product coefficient array or vector
+ `options.xMean`  optional additive output offset
+ `options.xStd`  optional multiplicative output scale

## Returns
+ `self`  TensorSpline instance

## Discussion

  Use this constructor when you already know the per-dimension
  knot vectors and tensor-product coefficients.
 
  ```matlab
  spline = TensorSpline([4 4], tKnot, xi);
  values = spline(xq, yq);
  ```
 
                
