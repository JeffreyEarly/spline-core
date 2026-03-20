---
layout: default
title: ConstrainedSpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 3
---

#  ConstrainedSpline

Constrained spline fit through data values.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef ConstrainedSpline < BSpline</code></pre></div></div>

## Overview
 
Local constraints are specified with a struct containing fields
`t` and `D`, so that f^(D)(t) = 0 at the supplied locations.
 
ConstrainedSpline supports both Gaussian least-squares fitting and
iteratively reweighted fitting for other distributions, together with
local derivative constraints and optional global shape constraints.
 
## Basic usage
 
Use `ConstrainedSpline` when you want to fit a spline to noisy
one-dimensional data, optionally enforcing local derivative
constraints or global shape constraints.
 
```matlab
tKnot = BSpline.knotPointsForDataPoints(t, K=4);
spline = ConstrainedSpline(t, x, 4, tKnot);
xq = spline(tQuery);
```
 
          


## Topics
+ Create a constrained spline
  + [`ConstrainedSpline`](/spline-core/classes/constrainedspline/constrainedspline.html) Create a constrained spline through samples x observed at t.
+ Inspect fit results
  + [`distribution`](/spline-core/classes/constrainedspline/distribution.html) Error model used while fitting the constrained spline.
  + [`t`](/spline-core/classes/constrainedspline/t.html) Observation locations used to fit the spline.
  + [`x`](/spline-core/classes/constrainedspline/x.html) Observation values used to fit the spline.
+ Analyze the fit
  + [`smoothingMatrix`](/spline-core/classes/constrainedspline/smoothingmatrix.html) Return the smoothing matrix that maps observations to fitted values.
+ Choose constraint locations
  + [`MinimumConstraintPoints`](/spline-core/classes/constrainedspline/minimumconstraintpoints.html) Return a minimal set of locations for universal derivative constraints.
+ Prepare knot sequences
  + [`terminatedKnotPoints`](/spline-core/classes/constrainedspline/terminatedknotpoints.html) Ensure the knot vector has K repeated knots at each boundary.


## Developer Topics
These items document internal implementation details and are not part of the primary public API.
+ Inspect fit results
  + [`CmInv`](/spline-core/classes/constrainedspline/cminv.html) Inverse coefficient covariance or normal-equation system matrix.
  + [`W`](/spline-core/classes/constrainedspline/w.html) Weight matrix or weights used by the fit.
  + [`X`](/spline-core/classes/constrainedspline/x_.html) Design matrix for the observation locations.
+ Methodology (Static methods)
  + [`ConstrainedSolution`](/spline-core/classes/constrainedspline/constrainedsolution.html) Solve the constrained weighted least-squares spline system.
  + [`IteratedLeastSquaresTensionSolution`](/spline-core/classes/constrainedspline/iteratedleastsquarestensionsolution.html) Solve a constrained spline fit with iteratively reweighted least squares.
  + [`PrecomputeSolutionMatrices`](/spline-core/classes/constrainedspline/precomputesolutionmatrices.html) Precompute reusable matrices for constrained spline fitting.
+ Utility
  + [`normalizeCachedVars`](/spline-core/classes/constrainedspline/normalizecachedvars.html) Normalize an optional cached-variable struct.
  + [`normalizeConstraints`](/spline-core/classes/constrainedspline/normalizeconstraints.html) Normalize an optional constraint specification struct.


---