---
layout: default
title: TrajectorySpline
parent: TrajectorySpline
grand_parent: Classes
nav_order: 1
mathjax: true
---

#  TrajectorySpline

Create a trajectory from canonical component-spline state.


---

## Declaration
```matlab
 self = TrajectorySpline(options)
```
## Parameters
+ `options.t`  strictly increasing shared trajectory parameter vector
+ `options.x`  one-dimensional spline for the x-coordinate
+ `options.y`  one-dimensional spline for the y-coordinate

## Returns
+ `self`  TrajectorySpline instance

## Discussion

  Use this low-level constructor when you already have the
  shared trajectory parameter and the one-dimensional component
  spline objects. For ordinary fitting from raw sample values,
  use `TrajectorySpline.fromData(...)`.

  ```matlab
  xSpline = ConstrainedSpline.fromGriddedValues(t, x, S=3);
  ySpline = ConstrainedSpline.fromGriddedValues(t, y, S=3);
  trajectory = TrajectorySpline(t=t, x=xSpline, y=ySpline);
  ```


