---
layout: default
title: power
parent: TensorSpline
grand_parent: Classes
nav_order: 18
mathjax: true
---

#  power

Raise tensor-spline values to a positive scalar power by refitting support values.


---

## Declaration
```matlab
 poweredSpline = power(self,exponent)
```
## Parameters
+ `self`  TensorSpline instance
+ `exponent`  positive scalar exponent

## Returns
+ `poweredSpline`  TensorSpline approximating spline.^exponent

## Discussion

  This is useful for simple nonlinear transforms of a tensor spline when
  an exact spline-space representation is not available.

  The implementation samples the spline on representative tensor support
  points, applies the power to those sampled values, chooses a new tensor
  basis, and refits the transformed samples. This is an approximation, not
  exact spline-space algebra.

  ```matlab
  squaredSpline = spline.^2;
  amplitudeSpline = spline.^(1/2);
  ```


