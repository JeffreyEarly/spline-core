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
 
      


## Topics
+ Initialization
  + [`InterpolatingTensorSpline`](/spline-core/classes/interpolatingtensorspline/interpolatingtensorspline.html) Create a tensor-product interpolating spline on a rectilinear grid.
+ Primary attributes
  + [`K`](/spline-core/classes/interpolatingtensorspline/k.html) Spline order in each tensor dimension.
  + [`basisSize`](/spline-core/classes/interpolatingtensorspline/basissize.html) Number of basis functions in each dimension.
  + [`domain`](/spline-core/classes/interpolatingtensorspline/domain.html) Coordinate limits for each dimension.
  + [`gridVectors`](/spline-core/classes/interpolatingtensorspline/gridvectors.html) Grid vectors used to define the interpolation lattice.
  + [`numDimensions`](/spline-core/classes/interpolatingtensorspline/numdimensions.html) Number of tensor dimensions.
  + [`tKnot`](/spline-core/classes/interpolatingtensorspline/tknot.html) Knot vectors for each tensor dimension.
  + [`x_mean`](/spline-core/classes/interpolatingtensorspline/x_mean.html) Mean added back to zero-order evaluations.
  + [`x_std`](/spline-core/classes/interpolatingtensorspline/x_std.html) Multiplicative scale applied to evaluations.
  + [`xi`](/spline-core/classes/interpolatingtensorspline/xi.html) Tensor-product spline coefficients reshaped to basisSize.
+ Methodology (Static methods)
  + [`matrix`](/spline-core/classes/interpolatingtensorspline/matrix.html) Evaluate the tensor-product basis matrix and optional derivatives.
  + [`pointsFromGridVectors`](/spline-core/classes/interpolatingtensorspline/pointsfromgridvectors.html) Convert rectilinear grid vectors into an explicit point matrix.
+ Operations
  + [`subsref`](/spline-core/classes/interpolatingtensorspline/subsref.html) Evaluate the tensor spline with function-call syntax or defer to built-in indexing.
  + [`valueAtPoints`](/spline-core/classes/interpolatingtensorspline/valueatpoints.html) Evaluate the tensor spline or a mixed partial derivative.


---