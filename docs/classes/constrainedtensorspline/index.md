---
layout: default
title: ConstrainedTensorSpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 6
---

#  ConstrainedTensorSpline

Tensor-product spline fit through noisy data values.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef ConstrainedTensorSpline < TensorSpline</code></pre></div></div>

## Overview
 
ConstrainedTensorSpline fits a tensor-product spline basis to noisy
observations using iteratively reweighted least squares. Constraint
handling is intentionally omitted in this first version.
 
          


## Topics
+ Initialization
  + [`ConstrainedTensorSpline`](/spline-core/classes/constrainedtensorspline/constrainedtensorspline.html) Create a tensor-product spline fit to noisy observations.
+ Primary attributes
  + [`CmInv`](/spline-core/classes/constrainedtensorspline/cminv.html) Inverse coefficient covariance or normal-equation system matrix.
  + [`W`](/spline-core/classes/constrainedtensorspline/w.html) Weight matrix or weights used by the fit.
  + [`X`](/spline-core/classes/constrainedtensorspline/x_.html) Design matrix for the observation locations.
  + [`Xobs`](/spline-core/classes/constrainedtensorspline/xobs.html) Observation locations as an N-by-D point matrix.
  + [`distribution`](/spline-core/classes/constrainedtensorspline/distribution.html) Error model used while fitting the tensor spline.
  + [`x`](/spline-core/classes/constrainedtensorspline/x.html) Observation values as an N-by-1 vector.
+ Operations
  + [`smoothingMatrix`](/spline-core/classes/constrainedtensorspline/smoothingmatrix.html) Return the smoothing matrix that maps observations to fitted values.
+ Methodology (Static methods)
  + [`tensorModelSolution`](/spline-core/classes/constrainedtensorspline/tensormodelsolution.html) Solve the tensor noisy-data model with iteratively reweighted least squares.


---