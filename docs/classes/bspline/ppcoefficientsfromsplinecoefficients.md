---
layout: default
title: ppCoefficientsFromSplineCoefficients
parent: BSpline
grand_parent: Classes
nav_order: 17
mathjax: true
---

#  ppCoefficientsFromSplineCoefficients

Returns the piecewise polynomial coefficients in matrix C from spline coefficients in vector xi.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 ppCoefficientsFromSplineCoefficients( xi, tKnot, K, Xtpp )
```
## Parameters
+ `xi`  spline coefficients
+ `tKnot`  spline knot points
+ `K`  spline order (degree S=K-1)
+ `options.Xtpp`  (optional) splines at the points tpp

## Returns
+ `C`  polynomial coefficients to be used in polyval, size(C) = [length(tpp)-1, K]
+ `tpp`  piece-wise polynomial intervals, size(tpp) = numel(tKnot) - 2*K + 1
+ `Xtpp`  splines at the points tpp

## Discussion

                    
