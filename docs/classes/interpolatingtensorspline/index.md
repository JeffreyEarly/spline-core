---
layout: default
title: InterpolatingTensorSpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 5
---

#  InterpolatingTensorSpline

Tensor-product interpolating spline on rectilinear grids.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef InterpolatingTensorSpline < TensorSpline</code></pre></div></div>

## Overview
 
InterpolatingTensorSpline builds a tensor-product spline that exactly
interpolates data defined on a rectilinear grid in one or more
dimensions.
 
## Basic usage
 
Use `InterpolatingTensorSpline` when you have values on a rectilinear
grid and want a tensor-product spline that matches them exactly.
 
```matlab
[X,Y] = ndgrid(linspace(0,1,8), linspace(-1,1,9));
F = sin(2*pi*X).*cos(pi*Y);
spline = InterpolatingTensorSpline(X(:,1), Y(1,:), F);
Fq = spline(X, Y);
```
 
    


## Topics
+ Create an interpolating tensor spline
  + [`InterpolatingTensorSpline`](/spline-core/classes/interpolatingtensorspline/interpolatingtensorspline.html) Create a tensor-product interpolating spline on a rectilinear grid.
+ Inspect interpolation grids
  + [`gridVectors`](/spline-core/classes/interpolatingtensorspline/gridvectors.html) Grid vectors used to define the interpolation lattice.


---
