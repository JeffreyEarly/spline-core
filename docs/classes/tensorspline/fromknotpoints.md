---
layout: default
title: fromKnotPoints
parent: TensorSpline
grand_parent: Classes
nav_order: 9
mathjax: true
---

#  fromKnotPoints

Create a tensor-product spline from numeric knot vectors and coefficients.


---

## Declaration
```matlab
 self = fromKnotPoints(knotPoints,xi,options)
```
## Parameters
+ `knotPoints`  numeric knot vector in 1-D or cell array of knot vectors
+ `xi`  tensor-product coefficient array or vector
+ `options.S`  spline degree scalar or vector with one entry per dimension
+ `options.xMean`  optional additive output offset
+ `options.xStd`  optional multiplicative output scale

## Returns
+ `self`  TensorSpline instance

## Discussion

  Use this factory for ordinary scientific construction when
  you have numeric knot vectors or a knot-vector cell array.


