---
layout: default
title: valueAtPoints
parent: TensorSpline
grand_parent: Classes
nav_order: 10
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

  Evaluate either on an `N x D` point matrix or on a cell array
  of matching query grids.
 
  ```matlab
  values = spline(queryPoints);
  valuesOnGrid = spline({X,Y});
  ```
 
            
