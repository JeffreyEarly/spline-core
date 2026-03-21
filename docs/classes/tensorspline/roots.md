---
layout: default
title: roots
parent: TensorSpline
grand_parent: Classes
nav_order: 14
mathjax: true
---

#  roots

Return real roots of a one-dimensional tensor spline within its domain.


---

## Declaration
```matlab
 values = roots(self)
```
## Parameters
+ `self`  TensorSpline instance

## Returns
+ `values`  sorted real roots in the spline domain

## Discussion

  Use this to locate zero crossings of a one-dimensional tensor spline
  over its support.
 
  ```matlab
  tZero = roots(spline);
  ```
 
        
