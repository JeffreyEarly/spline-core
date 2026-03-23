---
layout: default
title: equal
parent: PointConstraint
grand_parent: Classes
nav_order: 6
mathjax: true
---

#  equal

Create a pointwise equality constraint.


---

## Declaration
```matlab
 self = equal(points,options)
```
## Parameters
+ `points`  point locations as a vector or N-by-D matrix
+ `options.D`  derivative orders as a scalar, row vector, or N-by-D matrix
+ `options.Value`  scalar or one target value per point

## Returns
+ `self`  equality PointConstraint

## Discussion

  ```matlab
  c = PointConstraint.equal(tc, D=2, Value=0);
  ```


