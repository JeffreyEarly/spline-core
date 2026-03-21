---
layout: default
title: ConstrainedTensorSpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 5
---

#  ConstrainedTensorSpline

Tensor-product spline fit through noisy data values.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef ConstrainedTensorSpline < TensorSpline</code></pre></div></div>

## Overview
 
ConstrainedTensorSpline fits a tensor-product spline basis to noisy
observations using iteratively reweighted least squares together with
optional local point constraints and global shape constraints.
 
## Basic usage
 
Use `ConstrainedTensorSpline` when you want to fit a tensor-product
spline to noisy multivariate data.
 
```matlab
spline = ConstrainedTensorSpline(X, x);
xFit = spline(X);
```
 
      


## Topics
+ Create a constrained tensor spline
  + [`ConstrainedTensorSpline`](/spline-core/classes/constrainedtensorspline/constrainedtensorspline.html) Create a tensor-product spline fit to noisy observations.
+ Inspect fit results
  + [`Xobs`](/spline-core/classes/constrainedtensorspline/xobs.html) Observation locations as an N-by-D point matrix.
  + [`distribution`](/spline-core/classes/constrainedtensorspline/distribution.html) Error model used while fitting the tensor spline.
  + [`globalConstraints`](/spline-core/classes/constrainedtensorspline/globalconstraints.html) Global shape constraints used during fitting.
  + [`pointConstraints`](/spline-core/classes/constrainedtensorspline/pointconstraints.html) Local point constraints used during fitting.
  + [`x`](/spline-core/classes/constrainedtensorspline/x.html) Observation values as an N-by-1 vector.
+ Analyze the fit
  + [`smoothingMatrix`](/spline-core/classes/constrainedtensorspline/smoothingmatrix.html) Return the smoothing matrix that maps observations to fitted values.


## Developer Topics
These items document internal implementation details and are not part of the primary public API.
+ Inspect fit results
  + [`Aeq`](/spline-core/classes/constrainedtensorspline/aeq.html) Linear equality constraints applied to the coefficient solve.
  + [`Aineq`](/spline-core/classes/constrainedtensorspline/aineq.html) Linear inequality constraints applied to the coefficient solve.
  + [`CmInv`](/spline-core/classes/constrainedtensorspline/cminv.html) Inverse coefficient covariance or normal-equation system matrix.
  + [`W`](/spline-core/classes/constrainedtensorspline/w.html) Weight matrix or weights used by the fit.
  + [`X`](/spline-core/classes/constrainedtensorspline/x_.html) Design matrix for the observation locations.
  + [`beq`](/spline-core/classes/constrainedtensorspline/beq.html) Right-hand side for equality constraints.
  + [`bineq`](/spline-core/classes/constrainedtensorspline/bineq.html) Right-hand side for inequality constraints.
+ Methodology (Static methods)
  + [`tensorModelSolution`](/spline-core/classes/constrainedtensorspline/tensormodelsolution.html) Solve the tensor noisy-data model with iteratively reweighted least squares.


---