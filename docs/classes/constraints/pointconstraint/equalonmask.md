---
layout: default
title: equalOnMask
parent: PointConstraint
grand_parent: Classes
nav_order: 7
mathjax: true
---

#  equalOnMask

Create a pointwise equality constraint from a logical mask.


---

## Declaration
```matlab
 self = equalOnMask(grid,mask,options)
```
## Parameters
+ `grid`  vector or cell array of grid vectors or matching grid arrays
+ `mask`  logical mask selecting constrained locations
+ `options.D`  derivative orders as a scalar, row vector, or N-by-D matrix
+ `options.Value`  scalar or one target value per selected point

## Returns
+ `self`  equality PointConstraint

## Discussion

  Use this when a constrained region is naturally described by
  a logical mask on a rectilinear grid.

  ```matlab
  c = PointConstraint.equalOnMask({x,y}, mask, D=[0 0], Value=0);
  ```


