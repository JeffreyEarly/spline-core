---
layout: default
title: GlobalConstraint
parent: GlobalConstraint
grand_parent: Classes
nav_order: 2
mathjax: true
---

#  GlobalConstraint

Create a global constraint specification.


---

## Declaration
```matlab
 self = GlobalConstraint(shape,options)
```
## Parameters
+ `shape`  one of "none", "positive", "monotonicIncreasing", or "monotonicDecreasing"
+ `options.Dimension`  tensor dimension for directional constraints

## Returns
+ `self`  GlobalConstraint instance

## Discussion

  Use the static helper methods `positive`,
  `monotonicIncreasing`, and `monotonicDecreasing` for the
  intended public construction style.


