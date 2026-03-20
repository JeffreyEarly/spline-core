---
layout: default
title: valueAtPoints
parent: InterpolatingTensorSpline
grand_parent: Classes
nav_order: 11
mathjax: true
---

#  valueAtPoints

Evaluate the tensor spline or a mixed partial derivative.


---

## Declaration
```matlab
 values = valueAtPoints(self,X,derivativeOrders)
```
## Parameters
+ `self`  TensorSpline instance
+ `X`  query locations as a point matrix or cell array of matching grids
+ `derivativeOrders`  derivative order per dimension

## Returns
+ `values`  spline values reshaped to match the query input

## Discussion

            
