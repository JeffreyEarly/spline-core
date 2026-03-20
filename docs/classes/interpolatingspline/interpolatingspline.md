---
layout: default
title: InterpolatingSpline
parent: InterpolatingSpline
grand_parent: Classes
nav_order: 2
mathjax: true
---

#  InterpolatingSpline

Create an interpolating spline through samples x observed at t.


---

## Declaration
```matlab
 self = InterpolatingSpline(t,x,options)
```
## Parameters
+ `t`  sample locations
+ `x`  sample values
+ `options.K`  spline order, used when options.S is not supplied
+ `options.S`  spline degree, alternative to specifying options.K

## Returns
+ `self`  InterpolatingSpline instance

## Discussion

              
