---
layout: default
title: InterpolatingSpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 3
---

#  InterpolatingSpline

Interpolating spline on one-dimensional samples or rectilinear grids.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef InterpolatingSpline < TensorSpline</code></pre></div></div>

## Overview

`InterpolatingSpline` is the exact-fit counterpart to
`ConstrainedSpline`. Use
`InterpolatingSpline.fromGriddedValues(...)` when your samples live
on a one-dimensional grid or a rectilinear tensor grid and should be
reproduced exactly. The low-level `InterpolatingSpline(...)`
constructor is the cheap solved-state constructor used for persisted
restart and other direct bootstrap paths.

Supported construction forms:
  spline = InterpolatingSpline.fromGriddedValues(x, V)
  spline = InterpolatingSpline.fromGriddedValues({x, y, ...}, V)
  spline = InterpolatingSpline(S=S, knotAxes=..., xi=..., gridAxes=...)

If $$\mathbf{B}$$ is the tensor-product basis matrix on the supplied
grid and $$\tilde{y}$$ is the normalized data vector, the stored
coefficients are chosen so that

$$
\mathbf{B}\xi = \tilde{y}, \qquad
\tilde{y} = \frac{y - \bar{y}}{s_y},
$$

where $$xMean = \bar{y}$$ and $$xStd = s_y$$ are stored so later
evaluation returns values on the original scale.

## Basic usage

```matlab
x = linspace(0,1,8)';
y = linspace(-1,1,9)';
[X,Y] = ndgrid(x, y);
F = sin(2*pi*X).*cos(pi*Y);
spline = InterpolatingSpline.fromGriddedValues({x, y}, F, S=[3 3]);
Fq = spline(X, Y);
```




## Topics
+ Create an interpolating spline
  + [`InterpolatingSpline`](/spline-core/classes/interpolatingspline/interpolatingspline.html) Create an interpolating spline from canonical solved state.
  + [`fromGriddedValues`](/spline-core/classes/interpolatingspline/fromgriddedvalues.html) Create an interpolating spline from values on a rectilinear grid.
+ Inspect interpolation grids
  + [`gridAxes`](/spline-core/classes/interpolatingspline/gridaxes.html) Grid-axis objects used to define the interpolation lattice.
  + [`gridVectors`](/spline-core/classes/interpolatingspline/gridvectors.html) Grid vectors used to define the interpolation lattice.


---