---
layout: default
title: upperBound
parent: PointConstraint
grand_parent: Classes
nav_order: 10
mathjax: true
---

#  upperBound

Create a pointwise upper-bound constraint.


---

## Declaration
```matlab
 self = upperBound(points,options)
```
## Parameters
+ `points`  point locations as a vector or N-by-D matrix
+ `options.D`  derivative orders as a scalar, row vector, or N-by-D matrix
+ `options.Value`  scalar or one bound value per point

## Returns
+ `self`  upper-bound PointConstraint

## Discussion

  ```matlab
  c = PointConstraint.upperBound(P, D=[0 0], Value=1);
  ```
 
            
