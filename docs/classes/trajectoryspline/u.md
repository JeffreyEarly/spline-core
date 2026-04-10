---
layout: default
title: u
parent: TrajectorySpline
grand_parent: Classes
nav_order: 4
mathjax: true
---

#  u

Evaluate the x-velocity $$u(t) = \dot{x}(t)$$ along the trajectory.


---

## Declaration
```matlab
 values = u(self,t)
```
## Parameters
+ `t`  numeric query points with any shape

## Returns
+ `values`  x-derivative values with the same shape as `t`

## Discussion

  Use this method when the x-component derivative should be
  evaluated through the trajectory API rather than by reaching
  into the component spline directly.


