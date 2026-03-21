---
layout: default
title: lowerBound
parent: PointConstraint
grand_parent: Classes
nav_order: 8
mathjax: true
---

#  lowerBound

Create a pointwise lower-bound constraint.


---

## Declaration
```matlab
 self = lowerBound(points,options)
```
## Parameters
+ `points`  point locations as a vector or N-by-D matrix
+ `options.D`  derivative orders as a scalar, row vector, or N-by-D matrix
+ `options.Value`  scalar or one bound value per point

## Returns
+ `self`  lower-bound PointConstraint

## Discussion

  ```matlab
  c = PointConstraint.lowerBound(P, D=[0 1], Value=0);
  ```
 
            
