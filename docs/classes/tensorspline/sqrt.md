---
layout: default
title: sqrt
parent: TensorSpline
grand_parent: Classes
nav_order: 18
mathjax: true
---

#  sqrt

Return a tensor spline approximation to the square root of the spline output.


---

## Declaration
```matlab
 splinesqrt = sqrt(self)
```
## Parameters
+ `self`  TensorSpline instance

## Returns
+ `splinesqrt`  TensorSpline approximating sqrt(spline)

## Discussion

  This is a convenience wrapper around `spline.^(1/2)` and is most useful
  when the spline is nonnegative over its domain.

  ```matlab
  amplitudeSpline = sqrt(energySpline);
  ```


