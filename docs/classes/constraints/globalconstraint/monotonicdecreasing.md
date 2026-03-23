---
layout: default
title: monotonicDecreasing
parent: GlobalConstraint
grand_parent: Classes
nav_order: 3
mathjax: true
---

#  monotonicDecreasing

Create a monotone-decreasing constraint along one dimension.


---

## Declaration
```matlab
 self = monotonicDecreasing(options)
```
## Parameters
+ `options.dimension`  tensor dimension, default 1

## Returns
+ `self`  monotone-decreasing GlobalConstraint

## Discussion

  ```matlab
  c = GlobalConstraint.monotonicDecreasing(dimension=2);
  ```


