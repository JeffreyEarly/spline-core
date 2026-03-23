---
layout: default
title: monotonicIncreasing
parent: GlobalConstraint
grand_parent: Classes
nav_order: 3
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
+ `options.dimension`  tensor dimension, default 1

## Returns
+ `self`  monotone-increasing GlobalConstraint

## Discussion

  ```matlab
  c = GlobalConstraint.monotonicIncreasing(dimension=1);
  ```
 
        
