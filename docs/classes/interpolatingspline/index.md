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

`InterpolatingSpline` is the exact-fit constructor for data already
sampled on a one-dimensional grid or a rectilinear tensor grid. It is
the class to use when your samples are trusted exactly and you want a
spline whose evaluation reproduces those sample values at the supplied
grid locations.

Supported construction forms:
  spline = InterpolatingSpline(x,V)
  spline = InterpolatingSpline({x,y,...},V)
  spline = InterpolatingSpline(grid,V,S=S)

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

Use `InterpolatingSpline` when you have values on a rectilinear grid
and want exact interpolation rather than smoothing or constrained
regression.

```matlab
x = linspace(0,1,8)';
y = linspace(-1,1,9)';
[X,Y] = ndgrid(x, y);
F = sin(2*pi*X).*cos(pi*Y);
spline = InterpolatingSpline({x, y}, F);
Fq = spline(X, Y);
```




## Topics
+ Create an interpolating spline
  + [`InterpolatingSpline`](/spline-core/classes/interpolatingspline/interpolatingspline.html) Create an interpolating spline on one-dimensional samples or a rectilinear grid.
+ Inspect interpolation grids
  + [`gridVectors`](/spline-core/classes/interpolatingspline/gridvectors.html) Grid vectors used to define the interpolation lattice.


---