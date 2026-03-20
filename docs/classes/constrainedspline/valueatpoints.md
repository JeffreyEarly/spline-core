---
layout: default
title: valueAtPoints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 38
mathjax: true
---

#  valueAtPoints

Evaluate the spline or one of its derivatives at arbitrary points.


---

## Declaration
```matlab
 x_out = valueAtPoints(self,t,NumDerivatives)
```
## Parameters
+ `self`  BSpline instance
+ `t`  evaluation points
+ `NumDerivatives`  derivative order to evaluate

## Returns
+ `x_out`  array matching the shape of t

## Discussion

            - Note: derivative orders above K-1 evaluate to zero.
  
