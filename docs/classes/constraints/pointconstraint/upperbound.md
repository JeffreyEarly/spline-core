---
layout: default
title: upperBound
parent: PointConstraint
grand_parent: Classes
nav_order: 11
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
+ `options.value`  scalar or one bound value per point

## Returns
+ `self`  upper-bound PointConstraint

## Discussion

  ```matlab
  c = PointConstraint.upperBound(P, D=[0 0], value=1);
  ```
 
            
