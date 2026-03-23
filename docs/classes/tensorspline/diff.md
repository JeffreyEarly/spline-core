---
layout: default
title: diff
parent: TensorSpline
grand_parent: Classes
nav_order: 6
mathjax: true
---

#  diff

Return a tensor spline representing mixed partial derivatives.


---

## Declaration
```matlab
 dspline = diff(self,derivativeOrders)
```
## Parameters
+ `self`  TensorSpline instance
+ `derivativeOrders`  derivative order per dimension

## Returns
+ `dspline`  TensorSpline representing the derivative

## Discussion

  Use a scalar derivative order in 1-D or a derivative-order
  vector with one entry per dimension.

  The implementation differentiates the tensor-product coefficients along
  each requested dimension and reduces the degree in those dimensions by
  the corresponding derivative orders.

  ```matlab
  dspline = diff(spline);
  dFdx = diff(spline, [1 0]);
  ```


