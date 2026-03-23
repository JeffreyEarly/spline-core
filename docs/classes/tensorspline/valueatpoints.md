---
layout: default
title: valueAtPoints
parent: TensorSpline
grand_parent: Classes
nav_order: 21
mathjax: true
---

#  valueAtPoints

Evaluate the tensor spline or a mixed partial derivative.


---

## Declaration
```matlab
 values = valueAtPoints(self,X1,...,Xn,options)
```
## Parameters
+ `self`  TensorSpline instance
+ `X1,...,Xn`  matching-size query locations as one array per dimension
+ `options.D`  derivative order per dimension

## Returns
+ `values`  spline values reshaped to match the query input

## Discussion

  This is the primary explicit evaluation method. Supply one
  matching-size query array per tensor dimension.

  ```matlab
  values = spline(xq, yq);
  dFdx = spline.valueAtPoints(xq, yq, D=[1 0]);
  ```
