---
layout: default
title: fromData
parent: TrajectorySpline
grand_parent: Classes
nav_order: 2
mathjax: true
---

#  fromData

Create a trajectory spline from raw x(t) and y(t) samples.


---

## Declaration
```matlab
 self = fromData(t,x,y,options)
```
## Parameters
+ `t`  strictly increasing shared trajectory parameter vector
+ `x`  x-coordinate samples evaluated at `t`
+ `y`  y-coordinate samples evaluated at `t`
+ `options.S`  spline degree shared by both coordinate splines

## Returns
+ `self`  TrajectorySpline instance

## Discussion

  Use this factory when the coordinate components of a planar
  trajectory are known at the same parameter samples and should
  each be fit as a one-dimensional `ConstrainedSpline`.

  The resulting component models satisfy

  $$
  x(t_i) = x_i, \qquad y(t_i) = y_i,
  $$

  for each supplied sample pair `x_i`, `y_i` at parameter value
  `t_i`.

  ```matlab
  t = linspace(0, 1, 20)';
  x = cos(2*pi*t);
  y = sin(2*pi*t);
  trajectory = TrajectorySpline.fromData(t, x, y, S=3);
  ```


