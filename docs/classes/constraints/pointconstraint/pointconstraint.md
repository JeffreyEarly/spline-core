---
layout: default
title: PointConstraint
parent: PointConstraint
grand_parent: Classes
nav_order: 2
mathjax: true
---

#  PointConstraint

Create a pointwise equality or bound constraint.


---

## Declaration
```matlab
 self = PointConstraint(points,relation,value,options)
```
## Parameters
+ `points`  point locations as a vector or N-by-D matrix
+ `relation`  one of "==", ">=", or "<="
+ `value`  scalar or one target value per point
+ `options.D`  derivative orders as a scalar, row vector, or N-by-D matrix

## Returns
+ `self`  PointConstraint instance

## Discussion

  Use the static helper methods `equal`, `lowerBound`, and
  `upperBound` for the intended public construction style.
 
              
