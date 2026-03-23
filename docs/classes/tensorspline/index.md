---
layout: default
title: TensorSpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 2
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

xq = linspace(0,1,40)';
yq = linspace(0,1,40)';
F = spline(xq, yq);
```




## Topics
+ Create a spline
  + [`TensorSpline`](/spline-core/classes/tensorspline/tensorspline.html) Create a tensor-product spline from per-dimension orders, knots, and coefficients.
+ Inspect spline properties
  + [`K`](/spline-core/classes/tensorspline/k.html) Spline order in each tensor dimension.
  + [`S`](/spline-core/classes/tensorspline/s.html) Polynomial degree in each tensor dimension.
  + [`basisSize`](/spline-core/classes/tensorspline/basissize.html) Number of basis functions in each dimension.
  + [`domain`](/spline-core/classes/tensorspline/domain.html) Minimum and maximum values of the spline domain in each dimension.
  + [`numDimensions`](/spline-core/classes/tensorspline/numdimensions.html) Number of tensor dimensions.
  + [`tKnot`](/spline-core/classes/tensorspline/tknot.html) Knot vectors defining the spline basis.
  + [`xMean`](/spline-core/classes/tensorspline/xmean.html) Mean added back to zero-order evaluations.
  + [`xStd`](/spline-core/classes/tensorspline/xstd.html) Multiplicative scale applied to evaluations.
  + [`xi`](/spline-core/classes/tensorspline/xi.html) Tensor-product spline coefficients reshaped to basisSize.
+ Evaluate the spline
  + [`feval`](/spline-core/classes/tensorspline/feval.html) Evaluate a tensor spline at the supplied points.
  + [`subsref`](/spline-core/classes/tensorspline/subsref.html) Evaluate the tensor spline with function-call syntax or defer to built-in indexing.
  + [`valueAtPoints`](/spline-core/classes/tensorspline/valueatpoints.html) Evaluate the tensor spline or a mixed partial derivative.
+ Transform the spline
  + [`cumsum`](/spline-core/classes/tensorspline/cumsum.html) Return the indefinite integral along one tensor dimension.
  + [`diff`](/spline-core/classes/tensorspline/diff.html) Return a tensor spline representing mixed partial derivatives.
  + [`mtimes`](/spline-core/classes/tensorspline/mtimes.html) Multiply tensor-spline outputs by a scalar.
  + [`plus`](/spline-core/classes/tensorspline/plus.html) Add a scalar offset to tensor-spline outputs.
  + [`power`](/spline-core/classes/tensorspline/power.html) Raise tensor-spline values to a positive scalar power by refitting support values.
  + [`roots`](/spline-core/classes/tensorspline/roots.html) Return real roots of a one-dimensional tensor spline within its domain.
  + [`sqrt`](/spline-core/classes/tensorspline/sqrt.html) Return a tensor spline approximation to the square root of the spline output.
+ Build spline bases
  + [`matrix`](/spline-core/classes/tensorspline/matrix.html) Evaluate the tensor-product basis matrix and optional derivatives.
  + [`pointsFromGridVectors`](/spline-core/classes/tensorspline/pointsfromgridvectors.html) Convert rectilinear grid vectors into an explicit point matrix.
  + [`pointsOfSupport`](/spline-core/classes/tensorspline/pointsofsupport.html) Return representative support points for a tensor-product spline basis.


---