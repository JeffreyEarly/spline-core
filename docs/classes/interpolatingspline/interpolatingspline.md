---
layout: default
title: InterpolatingSpline
parent: InterpolatingSpline
grand_parent: Classes
nav_order: 1
mathjax: true
---

#  InterpolatingSpline

Create an interpolating spline on one-dimensional samples or a rectilinear grid.


---

## Declaration
```matlab
 self = InterpolatingSpline(grid,values,options)
```
## Parameters
+ `grid`  numeric vector in 1-D or cell array of grid vectors in higher dimensions
+ `values`  array of sampled values on the grid
+ `options.S`  spline degree scalar or vector with one entry per dimension

## Returns
+ `self`  InterpolatingSpline instance

## Discussion

  Use this constructor when your data already live on a
  rectilinear grid and should be reproduced exactly by the
  spline. Supply a numeric vector in 1-D or a cell array of grid
  vectors in higher dimensions together with the sampled value
  array.

  The implementation builds one knot vector per dimension from
  the supplied grid vectors, standardizes the sampled values, and
  solves the interpolation system

  $$
  \mathbf{B}\xi = \tilde{y},
  $$

  where $$\mathbf{B}$$ is the tensor-product basis matrix
  evaluated on the grid points. Because the knot vectors are
  built from the supplied grid, the resulting system is square
  for standard interpolation setups.

  ```matlab
  x = linspace(0,1,8)';
  y = linspace(-1,1,9)';
  [X,Y] = ndgrid(x, y);
  F = sin(2*pi*X).*cos(pi*Y);
  spline = InterpolatingSpline({x, y}, F, S=[3 3]);
  Fq = spline(X, Y);
  ```


