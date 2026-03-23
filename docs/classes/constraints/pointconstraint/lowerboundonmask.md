---
layout: default
title: lowerBoundOnMask
parent: PointConstraint
grand_parent: Classes
nav_order: 6
mathjax: true
---

#  lowerBoundOnMask

Create a pointwise lower-bound constraint from a logical mask.


---

## Declaration
```matlab
 self = lowerBoundOnMask(grid,mask,options)
```
## Parameters
+ `grid`  vector or cell array of grid vectors or matching grid arrays
+ `mask`  logical mask selecting constrained locations
+ `options.D`  derivative orders as a scalar, row vector, or N-by-D matrix
+ `options.value`  scalar or one bound value per selected point

## Returns
+ `self`  lower-bound PointConstraint

## Discussion

  ```matlab
  c = PointConstraint.lowerBoundOnMask({x,y}, mask, D=[0 1], value=0);
  ```


