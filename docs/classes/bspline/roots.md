---
layout: default
title: roots
parent: BSpline
grand_parent: Classes
nav_order: 18
mathjax: true
---

#  roots

Return real roots of a spline within its domain.


---

## Declaration
```matlab
 values = roots(spline)
```
## Parameters
+ `spline`  BSpline instance

## Returns
+ `values`  sorted real roots in the spline domain

## Discussion

  Use this to locate zero crossings of the spline over its support.

  ```matlab
  tZero = roots(spline);
  ```


