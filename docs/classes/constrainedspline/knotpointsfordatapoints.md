---
layout: default
title: knotPointsForDataPoints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 19
mathjax: true
---

#  knotPointsForDataPoints

Construct a terminated knot sequence from sample locations.


---

## Declaration
```matlab
 tKnot = knotPointsForDataPoints( t, options)
```
## Parameters
+ `t`  observation times (N)
+ `options.K`  (optional) spline order
+ `options.dataDOF`  (optional) stride used to subsample sorted data points before knot placement
+ `options.splineDOF`  (optional) approximate target number of splines, converted to dataDOF internally

## Returns
+ `tKnot`  vector of knot point locations

## Discussion

              
