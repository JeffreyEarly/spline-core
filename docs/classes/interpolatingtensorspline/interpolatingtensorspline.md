---
layout: default
title: InterpolatingTensorSpline
parent: InterpolatingTensorSpline
grand_parent: Classes
nav_order: 1
mathjax: true
---

#  InterpolatingTensorSpline

Create a tensor-product interpolating spline on a rectilinear grid.


---

## Declaration
```matlab
 self = InterpolatingTensorSpline(gridVectors,values,options)
```
## Parameters
+ `gridVectors`  cell array of grid vectors, one per dimension
+ `values`  array of sampled values on the grid
+ `options.K`  spline order scalar or vector with one entry per dimension
+ `options.S`  spline degree scalar or vector with one entry per dimension

## Returns
+ `self`  InterpolatingTensorSpline instance

## Discussion

  Use this constructor when your data already live on a
  rectilinear grid and should be reproduced exactly by the
  spline.
 
  ```matlab
  spline = InterpolatingTensorSpline({x,y}, F, K=[4 4]);
  Fq = spline({Xq,Yq});
  ```
 
              
