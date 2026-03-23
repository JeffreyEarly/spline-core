---
layout: default
title: monotonicDecreasing
parent: GlobalConstraint
grand_parent: Classes
nav_order: 4
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
+ `options.Dimension`  tensor dimension, default 1

## Returns
+ `self`  monotone-decreasing GlobalConstraint

## Discussion

  ```matlab
  c = GlobalConstraint.monotonicDecreasing(Dimension=2);
  ```


