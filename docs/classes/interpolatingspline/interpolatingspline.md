---
layout: default
title: InterpolatingSpline
parent: InterpolatingSpline
grand_parent: Classes
nav_order: 1
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

  This constructor chooses a terminated knot sequence from the
  sample locations and solves for coefficients that reproduce
  the supplied values exactly.
 
  ```matlab
  spline = InterpolatingSpline(t, x, K=4);
  xq = spline(tQuery);
  ```
 
              
