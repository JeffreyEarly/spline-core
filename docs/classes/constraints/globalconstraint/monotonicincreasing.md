---
layout: default
title: monotonicIncreasing
parent: GlobalConstraint
grand_parent: Classes
nav_order: 5
mathjax: true
---

#  monotonicIncreasing

Create a monotone-increasing constraint along one dimension.


---

## Declaration
```matlab
 self = monotonicIncreasing(options)
```
## Parameters
+ `options.Dimension`  tensor dimension, default 1

## Returns
+ `self`  monotone-increasing GlobalConstraint

## Discussion

  ```matlab
  c = GlobalConstraint.monotonicIncreasing(Dimension=1);
  ```


