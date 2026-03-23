---
layout: default
title: valueAtPoints
parent: BSpline
grand_parent: Classes
nav_order: 25
mathjax: true
---

#  valueAtPoints

Evaluate the spline or one of its derivatives at arbitrary points.


---

## Declaration
```matlab
 x_out = valueAtPoints(self,t,options)
```
## Parameters
+ `self`  BSpline instance
+ `t`  evaluation points
+ `options.D`  derivative order to evaluate

## Returns
+ `x_out`  array matching the shape of t

## Discussion

  This is the primary explicit evaluation method. Pass
  `D=0` for spline values, `D=1` for the first
  derivative, and so on.

  ```matlab
  x = spline.valueAtPoints(tQuery);
  d2x = spline.valueAtPoints(tQuery, D=2);
  ```

            - Note: derivative orders above K-1 evaluate to zero.
