---
layout: default
title: power
parent: TensorSpline
grand_parent: Classes
nav_order: 16
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

  ```matlab
  squaredSpline = spline.^2;
  amplitudeSpline = spline.^(1/2);
  ```


