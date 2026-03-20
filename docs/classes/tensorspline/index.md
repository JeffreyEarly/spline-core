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
 
          


## Topics
+ Initialization
  + [`TensorSpline`](/spline-core/classes/tensorspline/tensorspline.html) Create a tensor-product spline from per-dimension orders, knots, and coefficients.
+ Primary attributes
  + [`K`](/spline-core/classes/tensorspline/k.html) Spline order in each tensor dimension.
  + [`basisSize`](/spline-core/classes/tensorspline/basissize.html) Number of basis functions in each dimension.
  + [`domain`](/spline-core/classes/tensorspline/domain.html) Coordinate limits for each dimension.
  + [`numDimensions`](/spline-core/classes/tensorspline/numdimensions.html) Number of tensor dimensions.
  + [`tKnot`](/spline-core/classes/tensorspline/tknot.html) Knot vectors for each tensor dimension.
  + [`x_mean`](/spline-core/classes/tensorspline/x_mean.html) Mean added back to zero-order evaluations.
  + [`x_std`](/spline-core/classes/tensorspline/x_std.html) Multiplicative scale applied to evaluations.
  + [`xi`](/spline-core/classes/tensorspline/xi.html) Tensor-product spline coefficients reshaped to basisSize.
+ Operations
  + [`subsref`](/spline-core/classes/tensorspline/subsref.html) Evaluate the tensor spline with function-call syntax or defer to built-in indexing.
  + [`valueAtPoints`](/spline-core/classes/tensorspline/valueatpoints.html) Evaluate the tensor spline or a mixed partial derivative.
+ Methodology (Static methods)
  + [`matrix`](/spline-core/classes/tensorspline/matrix.html) Evaluate the tensor-product basis matrix and optional derivatives.
  + [`pointsFromGridVectors`](/spline-core/classes/tensorspline/pointsfromgridvectors.html) Convert rectilinear grid vectors into an explicit point matrix.


---