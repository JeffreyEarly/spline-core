---
layout: default
title: power
parent: BSpline
grand_parent: Classes
nav_order: 16
mathjax: true
---

#  power

Raise spline values to a real scalar power by refitting support values.


---

## Declaration
```matlab
 poweredSpline = power(spline,exponent,constraints)
```
## Parameters
+ `spline`  BSpline instance
+ `exponent`  scalar exponent
+ `constraints`  optional constraint specification for the refit

## Returns
+ `poweredSpline`  BSpline approximating spline.^exponent

## Discussion

            
