---
layout: default
title: cumsum
parent: BSpline
grand_parent: Classes
nav_order: 6
mathjax: true
---

#  cumsum

Return the indefinite integral of a B-spline.


---

## Declaration
```matlab
 intspline = cumsum(spline)
```
## Parameters
+ `spline`  BSpline instance to integrate

## Returns
+ `intspline`  BSpline representing the antiderivative

## Discussion

  Use this to construct an antiderivative spline that can be evaluated at
  arbitrary points after integration.
 
  ```matlab
  F = cumsum(spline);
  values = F(tQuery);
  ```
 
        
