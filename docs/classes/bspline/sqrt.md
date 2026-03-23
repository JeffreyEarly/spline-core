---
layout: default
title: sqrt
parent: BSpline
grand_parent: Classes
nav_order: 21
mathjax: true
---

#  sqrt

Return a spline approximation to the square root of the spline output.


---

## Declaration
```matlab
 splinesqrt = sqrt(spline)
```
## Parameters
+ `spline`  BSpline instance

## Returns
+ `splinesqrt`  BSpline approximating sqrt(spline)

## Discussion

  This is a convenience wrapper around `spline.^(1/2)` and is most useful
  when the spline is nonnegative over its domain.

  ```matlab
  amplitudeSpline = sqrt(energySpline);
  ```


