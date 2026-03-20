---
layout: default
title: TensorSpline
parent: TensorSpline
grand_parent: Classes
nav_order: 2
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
+ `options.x_mean`  optional additive output offset
+ `options.x_std`  optional multiplicative output scale

## Returns
+ `self`  TensorSpline instance

## Discussion

                
