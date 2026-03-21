---
layout: default
title: TensorSpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 4
---

#  TensorSpline

Tensor-product spline over multiple dimensions.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef TensorSpline < handle</code></pre></div></div>

## Overview
 
TensorSpline represents a tensor-product basis assembled from
one-dimensional B-spline bases in each coordinate direction. It
supports direct evaluation on point clouds or query grids together
with mixed partial derivatives.
 
## Basic usage
 
Use `TensorSpline` when you already have knot vectors and
tensor-product coefficients and want to evaluate the resulting
spline on points or grids.
 
```matlab
tKnot = {[0;0;0;0;1;1;1;1], [0;0;0;0;1;1;1;1]};
xi = randn(16,1);
spline = TensorSpline([4 4], tKnot, xi);
 
[X,Y] = ndgrid(linspace(0,1,40), linspace(0,1,50));
F = spline(X, Y);
```
 
        


## Topics
+ Create a tensor spline
  + [`TensorSpline`](/spline-core/classes/tensorspline/tensorspline.html) Create a tensor-product spline from per-dimension orders, knots, and coefficients.
+ Inspect tensor spline properties
  + [`K`](/spline-core/classes/tensorspline/k.html) Spline order in each tensor dimension.
  + [`basisSize`](/spline-core/classes/tensorspline/basissize.html) Number of basis functions in each dimension.
  + [`domain`](/spline-core/classes/tensorspline/domain.html) Coordinate limits for each dimension.
  + [`numDimensions`](/spline-core/classes/tensorspline/numdimensions.html) Number of tensor dimensions.
  + [`tKnot`](/spline-core/classes/tensorspline/tknot.html) Knot vectors for each tensor dimension.
  + [`xMean`](/spline-core/classes/tensorspline/xmean.html) Mean added back to zero-order evaluations.
  + [`xStd`](/spline-core/classes/tensorspline/xstd.html) Multiplicative scale applied to evaluations.
  + [`xi`](/spline-core/classes/tensorspline/xi.html) Tensor-product spline coefficients reshaped to basisSize.
+ Evaluate the tensor spline
  + [`subsref`](/spline-core/classes/tensorspline/subsref.html) Evaluate the tensor spline with function-call syntax or defer to built-in indexing.
  + [`valueAtPoints`](/spline-core/classes/tensorspline/valueatpoints.html) Evaluate the tensor spline or a mixed partial derivative.
+ Build tensor spline bases
  + [`matrix`](/spline-core/classes/tensorspline/matrix.html) Evaluate the tensor-product basis matrix and optional derivatives.
  + [`pointsFromGridVectors`](/spline-core/classes/tensorspline/pointsfromgridvectors.html) Convert rectilinear grid vectors into an explicit point matrix.


---
