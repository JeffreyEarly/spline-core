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

Supported construction forms:
  spline = InterpolatingSpline(x,V)
  spline = InterpolatingSpline({x,y,...},V)
  spline = InterpolatingSpline(grid,V,K=K)
  spline = InterpolatingSpline(grid,V,S=S)

## Basic usage

Use `InterpolatingSpline` when you have values on one-dimensional
samples or a rectilinear grid and want a spline that matches them
exactly.

```matlab
[X,Y] = ndgrid(linspace(0,1,8), linspace(-1,1,9));
F = sin(2*pi*X).*cos(pi*Y);
spline = InterpolatingSpline({X(:,1), Y(1,:)}, F);
Fq = spline(X, Y);
```




## Topics
+ Create an interpolating spline
  + [`InterpolatingSpline`](/spline-core/classes/interpolatingspline/interpolatingspline.html) Create an interpolating spline on one-dimensional samples or a rectilinear grid.
+ Inspect interpolation grids
  + [`gridVectors`](/spline-core/classes/interpolatingspline/gridvectors.html) Grid vectors used to define the interpolation lattice.


---