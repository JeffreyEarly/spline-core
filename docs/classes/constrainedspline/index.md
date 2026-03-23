---
layout: default
title: ConstrainedSpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 4
---

#  ConstrainedSpline

Tensor-product spline fit through noisy data values.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef ConstrainedSpline < TensorSpline</code></pre></div></div>

## Overview

`ConstrainedSpline` is the noisy-data fitting counterpart to
`InterpolatingSpline`. It fits a tensor-product spline basis to values
sampled on a one-dimensional grid or a rectilinear tensor grid, with
optional robust weighting, observation covariance, local point
constraints, and global shape constraints.

At each iteratively reweighted least-squares step it solves

$$
\min_{\xi}\ (y - \mathbf{B}\xi)^{T} W (y - \mathbf{B}\xi)
$$

subject to

$$
A_{\mathrm{eq}}\xi = b_{\mathrm{eq}}, \qquad
A_{\mathrm{ineq}}\xi \le b_{\mathrm{ineq}}.
$$

When the distribution model provides correlated errors, the code
forms a covariance model from the per-observation variances and the
correlation kernel, then solves the weighted system through a matrix
factorization rather than explicitly inverting the covariance.

## Basic usage

Use `ConstrainedSpline` when you want to fit a tensor-product
spline to noisy values on a one-dimensional grid or rectilinear grid.

```matlab
x = linspace(0,1,20)';
y = exp(-20*(x-0.5).^2) + 0.05*randn(size(x));
spline = ConstrainedSpline(x, y, S=3, constraints=GlobalConstraint.positive());
yFit = spline(x);
```




## Topics
+ Create a constrained tensor spline
  + [`ConstrainedSpline`](/spline-core/classes/constrainedspline/constrainedspline.html) Create a tensor-product spline fit to noisy observations.
+ Inspect fit results
  + [`dataPoints`](/spline-core/classes/constrainedspline/datapoints.html) Observation locations as an N-by-D point matrix.
  + [`dataValues`](/spline-core/classes/constrainedspline/datavalues.html) Observation values as an N-by-1 vector.
  + [`distribution`](/spline-core/classes/constrainedspline/distribution.html) Error model used while fitting the tensor spline.
  + [`globalConstraints`](/spline-core/classes/constrainedspline/globalconstraints.html) Global shape constraints used during fitting.
  + [`gridVectors`](/spline-core/classes/constrainedspline/gridvectors.html) Grid vectors used to define the fitted rectilinear lattice.
  + [`pointConstraints`](/spline-core/classes/constrainedspline/pointconstraints.html) Local point constraints used during fitting.
+ Analyze the fit
  + [`smoothingMatrix`](/spline-core/classes/constrainedspline/smoothingmatrix.html) Return the smoothing matrix that maps observations to fitted values.
+ Choose constraint locations
  + [`minimumConstraintPoints`](/spline-core/classes/constrainedspline/minimumconstraintpoints.html) Return a minimal set of one-dimensional locations for universal derivative constraints.
+ Prepare knot sequences
  + [`terminatedKnotPoints`](/spline-core/classes/constrainedspline/terminatedknotpoints.html) Ensure each knot vector has S+1 repeated knots at its boundaries.


---