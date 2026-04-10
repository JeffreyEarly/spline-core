---
layout: default
title: TrajectorySpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 5
---

#  TrajectorySpline

Two-dimensional trajectory model parameterized by a shared scalar variable.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef TrajectorySpline < CAAnnotatedClass</code></pre></div></div>

## Overview

`TrajectorySpline` stores a planar parametric trajectory as two
one-dimensional component splines,

$$
x = x(t), \qquad y = y(t),
$$

built from a shared parameter vector `t`. Use
`TrajectorySpline.fromData(...)` when raw coordinate samples should be
fit as one-dimensional `ConstrainedSpline` objects. The low-level
`TrajectorySpline(...)` constructor is the cheap canonical constructor
used for persisted restart and other direct bootstrap paths.

```matlab
t = linspace(0, 1, 20)';
x = cos(2*pi*t);
y = sin(2*pi*t);

trajectory = TrajectorySpline.fromData(t, x, y, S=3);
xq = trajectory.x(t);
yq = trajectory.y(t);
```




## Topics
+ Create a trajectory spline
  + [`TrajectorySpline`](/spline-core/classes/trajectoryspline/trajectoryspline.html) Create a trajectory from canonical component-spline state.
  + [`fromData`](/spline-core/classes/trajectoryspline/fromdata.html) Create a trajectory spline from raw x(t) and y(t) samples.
+ Inspect trajectory properties
  + [`t`](/spline-core/classes/trajectoryspline/t.html) Parameter samples shared by both component splines.
  + [`x`](/spline-core/classes/trajectoryspline/x.html) One-dimensional spline for the x-coordinate trajectory component.
  + [`y`](/spline-core/classes/trajectoryspline/y.html) One-dimensional spline for the y-coordinate trajectory component.
+ Evaluate trajectory derivatives
  + [`u`](/spline-core/classes/trajectoryspline/u.html) Evaluate the x-velocity $$u(t) = \dot{x}(t)$$ along the trajectory.
  + [`v`](/spline-core/classes/trajectoryspline/v.html) Evaluate the y-velocity $$v(t) = \dot{y}(t)$$ along the trajectory.


---