---
layout: default
title: v
parent: TrajectorySpline
grand_parent: Classes
nav_order: 5
mathjax: true
---

#  v

Evaluate the y-velocity $$v(t) = \dot{y}(t)$$ along the trajectory.


---

## Declaration
```matlab
 values = v(self,t)
```
## Parameters
+ `t`  numeric query points with any shape

## Returns
+ `values`  y-derivative values with the same shape as `t`

## Discussion

  Use this method when the y-component derivative should be
  evaluated through the trajectory API rather than by reaching
  into the component spline directly.


