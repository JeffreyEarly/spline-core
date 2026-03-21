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
 self = InterpolatingSpline(X1,...,Xn,values,options)
```
## Parameters
+ `X1,...,Xn`  grid vectors, one per dimension
+ `values`  array of sampled values on the grid
+ `options.K`  spline order scalar or vector with one entry per dimension
+ `options.S`  spline degree scalar or vector with one entry per dimension

## Returns
+ `self`  InterpolatingSpline instance

## Discussion

  Use this constructor when your data already live on a
  rectilinear grid and should be reproduced exactly by the
  spline. Supply one grid input per dimension followed by the
  sampled value array.
 
  ```matlab
  spline = InterpolatingSpline(x, y, F, K=[4 4]);
  Fq = spline(Xq, Yq);
  ```
 
              
