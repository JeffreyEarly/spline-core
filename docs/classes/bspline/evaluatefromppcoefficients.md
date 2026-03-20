---
layout: default
title: evaluateFromPPCoefficients
parent: BSpline
grand_parent: Classes
nav_order: 9
mathjax: true
---

#  evaluateFromPPCoefficients

Returns the value of the function with derivative D represented by PP coefficients C at locations t.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 f = evaluateFromPPCoefficients(t,C,tpp, D)
```
## Parameters
+ `t`  points at which to evaluate the splines
+ `C`  polynomial coefficients to be used in polyval, size(C) = [length(tpp)-1, K]
+ `tpp`  piece-wise polynomial intervals
+ `D`  number of derivatives

## Returns
+ `f`  array the same size as t

## Discussion

                
