---
layout: default
title: upperBoundOnMask
parent: PointConstraint
grand_parent: Classes
nav_order: 12
mathjax: true
---

#  upperBoundOnMask

Create a pointwise upper-bound constraint from a logical mask.


---

## Declaration
```matlab
 self = upperBoundOnMask(grid,mask,options)
```
## Parameters
+ `grid`  vector or cell array of grid vectors or matching grid arrays
+ `mask`  logical mask selecting constrained locations
+ `options.D`  derivative orders as a scalar, row vector, or N-by-D matrix
+ `options.value`  scalar or one bound value per selected point

## Returns
+ `self`  upper-bound PointConstraint

## Discussion

  ```matlab
  c = PointConstraint.upperBoundOnMask({x,y}, mask, D=[0 0], value=1);
  ```


