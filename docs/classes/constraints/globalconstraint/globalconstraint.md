---
layout: default
title: GlobalConstraint
parent: GlobalConstraint
grand_parent: Classes
nav_order: 1
mathjax: true
---

#  GlobalConstraint

Create a global spline-constraint object.


---

## Declaration
```matlab
 self = GlobalConstraint(options)
```
## Parameters
+ `options.shape`  global constraint shape identifier
+ `options.dimension`  optional tensor dimension for monotonic constraints

## Returns
+ `self`  GlobalConstraint instance

## Discussion

  Use the static helper methods `positive`,
  `monotonicIncreasing`, and `monotonicDecreasing` for the
  intended public construction style.


