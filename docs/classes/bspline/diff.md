---
layout: default
title: diff
parent: BSpline
grand_parent: Classes
nav_order: 7
mathjax: true
---

#  diff

Differentiate a B-spline representation.


---

## Declaration
```matlab
 dspline = diff(spline,n)
```
## Parameters
+ `spline`  BSpline instance to differentiate
+ `n`  derivative order

## Returns
+ `dspline`  BSpline representing the nth derivative

## Discussion

  Use this when you want a new spline object representing the derivative,
  rather than only evaluating derivatives at a set of points.
 
  ```matlab
  dspline = diff(spline);
  curvatureSpline = diff(spline, 2);
  ```
 
          
