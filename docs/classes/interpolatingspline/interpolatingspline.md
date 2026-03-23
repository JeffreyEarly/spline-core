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
+ `options.K`  spline order scalar or vector with one entry per dimension
+ `options.S`  spline degree scalar or vector with one entry per dimension

## Returns
+ `self`  InterpolatingSpline instance

## Discussion

  Use this constructor when your data already live on a
  rectilinear grid and should be reproduced exactly by the spline.
  Supply a numeric vector in 1-D or a cell array of grid vectors
  in higher dimensions together with the sampled value array.

  ```matlab
  spline = InterpolatingSpline({x, y}, F, K=[4 4]);
  Fq = spline(Xq, Yq);
  ```


