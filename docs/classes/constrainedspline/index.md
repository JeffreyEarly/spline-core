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
 
ConstrainedSpline fits a tensor-product spline basis to noisy
observations using iteratively reweighted least squares together with
optional local point constraints and global shape constraints.
 
## Basic usage
 
Use `ConstrainedSpline` when you want to fit a tensor-product
spline to noisy multivariate data.
 
```matlab
spline = ConstrainedSpline(points, values);
valuesFit = spline(Xq, Yq);
```
 
          


## Topics
+ Create a constrained tensor spline
  + [`ConstrainedSpline`](/spline-core/classes/constrainedspline/constrainedspline.html) Create a tensor-product spline fit to noisy observations.
+ Inspect fit results
  + [`distribution`](/spline-core/classes/constrainedspline/distribution.html) Error model used while fitting the tensor spline.
  + [`globalConstraints`](/spline-core/classes/constrainedspline/globalconstraints.html) Global shape constraints used during fitting.
  + [`pointConstraints`](/spline-core/classes/constrainedspline/pointconstraints.html) Local point constraints used during fitting.
  + [`points`](/spline-core/classes/constrainedspline/points.html) Observation locations as an N-by-D point matrix.
  + [`values`](/spline-core/classes/constrainedspline/values.html) Observation values as an N-by-1 vector.
+ Analyze the fit
  + [`smoothingMatrix`](/spline-core/classes/constrainedspline/smoothingmatrix.html) Return the smoothing matrix that maps observations to fitted values.
+ Choose constraint locations
  + [`minimumConstraintPoints`](/spline-core/classes/constrainedspline/minimumconstraintpoints.html) Return a minimal set of one-dimensional locations for universal derivative constraints.
+ Prepare knot sequences
  + [`terminatedKnotPoints`](/spline-core/classes/constrainedspline/terminatedknotpoints.html) Ensure each knot vector has K repeated knots at its boundaries.


## Developer Topics
These items document internal implementation details and are not part of the primary public API.
+ Inspect fit results
  + [`Aeq`](/spline-core/classes/constrainedspline/aeq.html) Linear equality constraints applied to the coefficient solve.
  + [`Aineq`](/spline-core/classes/constrainedspline/aineq.html) Linear inequality constraints applied to the coefficient solve.
  + [`CmInv`](/spline-core/classes/constrainedspline/cminv.html) Inverse coefficient covariance or normal-equation system matrix.
  + [`W`](/spline-core/classes/constrainedspline/w.html) Weight matrix or weights used by the fit.
  + [`X`](/spline-core/classes/constrainedspline/x.html) Design matrix for the observation locations.
  + [`beq`](/spline-core/classes/constrainedspline/beq.html) Right-hand side for equality constraints.
  + [`bineq`](/spline-core/classes/constrainedspline/bineq.html) Right-hand side for inequality constraints.
+ Methodology (Static methods)
  + [`constraintArguments`](/spline-core/classes/constrainedspline/constraintarguments.html) Normalize mixed constraint inputs into constructor arguments.
  + [`tensorModelSolution`](/spline-core/classes/constrainedspline/tensormodelsolution.html) Solve the tensor noisy-data model with iteratively reweighted least squares.


---