---
layout: default
title: sqrt
parent: BSpline
grand_parent: Classes
nav_order: 20
mathjax: true
---

#  sqrt

Return a spline approximation to the square root of the spline output.


---

## Declaration
```matlab
 splinesqrt = sqrt(spline,constraints)
```
## Parameters
+ `spline`  BSpline instance
+ `constraints`  optional constraint specification for the refit

## Returns
+ `splinesqrt`  BSpline approximating sqrt(spline)

## Discussion

  This is a convenience wrapper around `spline.^(1/2)` and is most useful
  when the spline is nonnegative over its domain.

  ```matlab
  amplitudeSpline = sqrt(energySpline);
  ```


