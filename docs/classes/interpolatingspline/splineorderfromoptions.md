---
layout: default
title: splineOrderFromOptions
parent: InterpolatingSpline
grand_parent: Classes
nav_order: 2
mathjax: true
---

#  splineOrderFromOptions

Resolve spline order from mutually exclusive K and S options.


---

## Declaration
```matlab
 K = splineOrderFromOptions(options)
```
## Parameters
+ `options`  struct with fields K and S

## Returns
+ `K`  spline order

## Discussion

  Use this helper when you need to mirror the constructor logic
  for choosing spline order from `K` or degree `S`.
 
  ```matlab
  K = InterpolatingSpline.splineOrderFromOptions(struct("S",3,"K",4));
  ```
 
        
