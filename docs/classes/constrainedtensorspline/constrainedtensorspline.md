---
layout: default
title: ConstrainedTensorSpline
parent: ConstrainedTensorSpline
grand_parent: Classes
nav_order: 4
mathjax: true
---

#  ConstrainedTensorSpline

Create a tensor-product spline fit to noisy observations.


---

## Declaration
```matlab
 self = ConstrainedTensorSpline(X,x,options)
```
## Parameters
+ `X`  observation locations as a point matrix or cell array of matching grids
+ `x`  observation values
+ `options.K`  optional spline order scalar or vector with one entry per dimension
+ `options.tKnot`  optional cell array of knot vectors
+ `options.distribution`  optional error model object for the fit
+ `options.pointConstraints`  optional PointConstraint array
+ `options.globalConstraints`  optional GlobalConstraint array

## Returns
+ `self`  ConstrainedTensorSpline instance

## Discussion

  Use this constructor with an `N x D` point matrix or a cell
  array of matching grids when fitting noisy tensor-product
  data.
 
  ```matlab
  spline = ConstrainedTensorSpline(X, x, K=[4 4]);
  xFit = spline(X);
  ```
 
                    
