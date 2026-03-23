---
layout: default
title: ConstrainedSpline
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 1
mathjax: true
---

#  ConstrainedSpline

Create a tensor-product spline fit to noisy observations.


---

## Declaration
```matlab
 self = ConstrainedSpline(grid,values,options)
```
## Parameters
+ `grid`  numeric vector in 1-D or cell array of grid vectors in higher dimensions
+ `values`  observation values
+ `options.S`  optional spline degree scalar or vector with one entry per dimension
+ `options.knotPoints`  optional knot vector in 1-D or cell array of knot vectors
+ `options.splineDOF`  optional target number of splines per dimension
+ `options.distribution`  optional error model object for the fit
+ `options.constraints`  optional mixed SplineConstraint array

## Returns
+ `self`  ConstrainedSpline instance

## Discussion

  Use this constructor with a numeric vector in 1-D or a cell
  array of grid vectors in higher dimensions when fitting noisy
  tensor-product data sampled on a rectilinear grid.

  If the design matrix is $$\mathbf{B}$$, the coefficient vector
  is estimated by an iteratively reweighted least-squares solve
  with optional linear equality and inequality constraints. The
  weights are updated from the current residuals through the
  supplied error `distribution`.

  In one dimension, `S=N-1` together with `splineDOF=N` gives the
  same least-squares polynomial fit as `polyfit(t,x,N-1)`.

  ```matlab
  x = linspace(0,1,20)';
  y = exp(-20*(x-0.5).^2) + 0.05*randn(size(x));
  spline = ConstrainedSpline(x, y, S=3, constraints=GlobalConstraint.positive());
  yFit = spline(x);
  ```


