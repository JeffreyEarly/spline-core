---
layout: default
title: valueAtPoints
parent: TensorSpline
grand_parent: Classes
nav_order: 20
mathjax: true
---

#  valueAtPoints

Evaluate the tensor spline or a mixed partial derivative.


---

## Declaration
```matlab
 values = valueAtPoints(self,X1,...,Xn,derivativeOrders)
```
## Parameters
+ `self`  TensorSpline instance
+ `X1,...,Xn`  query locations as a point matrix or one array per dimension
+ `derivativeOrders`  derivative order per dimension

## Returns
+ `values`  spline values reshaped to match the query input

## Discussion

  Evaluate either on an `N x D` point matrix or with one query
  input per tensor dimension.

  ```matlab
  values = spline(queryPoints);
  values = spline(xq, yq);
  ```


