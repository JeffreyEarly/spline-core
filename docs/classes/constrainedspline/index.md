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
 
        


## Topics
+ Initialization
  + [`ConstrainedSpline`](/spline-core/classes/constrainedspline/constrainedspline.html) Create a constrained spline through samples x observed at t.
+ Operations
  + [`cumsum`](/spline-core/classes/constrainedspline/cumsum.html) Return the indefinite integral of a B-spline.
  + [`diff`](/spline-core/classes/constrainedspline/diff.html) Differentiate a B-spline representation.
  + [`feval`](/spline-core/classes/constrainedspline/feval.html) Evaluate a B-spline at the supplied points.
  + [`mtimes`](/spline-core/classes/constrainedspline/mtimes.html) Multiply a spline output by a scalar.
  + [`plus`](/spline-core/classes/constrainedspline/plus.html) Add a scalar offset to a spline output.
  + [`power`](/spline-core/classes/constrainedspline/power.html) Raise spline values to a real scalar power by refitting support values.
  + [`roots`](/spline-core/classes/constrainedspline/roots.html) Return real roots of a spline within its domain.
  + [`smoothingMatrix`](/spline-core/classes/constrainedspline/smoothingmatrix.html) Return the smoothing matrix that maps observations to fitted values.
  + [`sqrt`](/spline-core/classes/constrainedspline/sqrt.html) Return a spline approximation to the square root of the spline output.
  + [`subsref`](/spline-core/classes/constrainedspline/subsref.html) Evaluate the spline with function-call syntax or defer to built-in indexing.
  + [`valueAtPoints`](/spline-core/classes/constrainedspline/valueatpoints.html) Evaluate the spline or one of its derivatives at arbitrary points.
+ Utility
  + [`normalizeCachedVars`](/spline-core/classes/constrainedspline/normalizecachedvars.html) Normalize an optional cached-variable struct.
  + [`normalizeConstraints`](/spline-core/classes/constrainedspline/normalizeconstraints.html) Normalize an optional constraint specification struct.
  + [`pointsOfSupport`](/spline-core/classes/constrainedspline/pointsofsupport.html) Return representative support points for a terminated spline basis.
  + [`splineCoefficientsDidChange`](/spline-core/classes/constrainedspline/splinecoefficientsdidchange.html) Refresh cached polynomial coefficients after coefficient updates.
  + [`tKnotDidChange`](/spline-core/classes/constrainedspline/tknotdidchange.html) Clear cached piecewise-polynomial data after knot updates.
  + [`terminatedKnotPoints`](/spline-core/classes/constrainedspline/terminatedknotpoints.html) Ensure the knot vector has K repeated knots at each boundary.
+ Methodology (Static methods)
  + [`ConstrainedSolution`](/spline-core/classes/constrainedspline/constrainedsolution.html) Solve the constrained weighted least-squares spline system.
  + [`IteratedLeastSquaresTensionSolution`](/spline-core/classes/constrainedspline/iteratedleastsquarestensionsolution.html) Solve a constrained spline fit with iteratively reweighted least squares.
  + [`MinimumConstraintPoints`](/spline-core/classes/constrainedspline/minimumconstraintpoints.html) Return a minimal set of locations for universal derivative constraints.
  + [`PrecomputeSolutionMatrices`](/spline-core/classes/constrainedspline/precomputesolutionmatrices.html) Precompute reusable matrices for constrained spline fitting.
  + [`knotPointsForDataPoints`](/spline-core/classes/constrainedspline/knotpointsfordatapoints.html) Construct a terminated knot sequence from sample locations.
+ Spline evaluation
  + [`C`](/spline-core/classes/constrainedspline/c.html) Piecewise-polynomial coefficients for interval evaluation.
  + [`Xtpp`](/spline-core/classes/constrainedspline/xtpp.html) Basis values and derivatives sampled at piecewise breakpoints.
  + [`evaluateFromPPCoefficients`](/spline-core/classes/constrainedspline/evaluatefromppcoefficients.html) Returns the value of the function with derivative D represented by PP coefficients C at locations t.
  + [`matrix`](/spline-core/classes/constrainedspline/matrix.html) Evaluate terminated B-spline basis functions and optional derivatives.
  + [`ppCoefficientsFromSplineCoefficients`](/spline-core/classes/constrainedspline/ppcoefficientsfromsplinecoefficients.html) Returns the piecewise polynomial coefficients in matrix C from spline coefficients in vector xi.
  + [`t_pp`](/spline-core/classes/constrainedspline/t_pp.html) Piecewise-polynomial breakpoint locations.
+ Primary attributes
  + [`CmInv`](/spline-core/classes/constrainedspline/cminv.html) Inverse coefficient covariance or normal-equation system matrix.
  + [`K`](/spline-core/classes/constrainedspline/k.html) Spline order K, where polynomial degree is S = K - 1.
  + [`S`](/spline-core/classes/constrainedspline/s.html) Polynomial degree S = K - 1.
  + [`W`](/spline-core/classes/constrainedspline/w.html) Weight matrix or weights used by the fit.
  + [`X`](/spline-core/classes/constrainedspline/x_.html) Design matrix for the observation locations.
  + [`distribution`](/spline-core/classes/constrainedspline/distribution.html) Error model used while fitting the constrained spline.
  + [`domain`](/spline-core/classes/constrainedspline/domain.html) Minimum and maximum values of the spline domain.
  + [`t`](/spline-core/classes/constrainedspline/t.html) Observation locations used to fit the spline.
  + [`tKnot`](/spline-core/classes/constrainedspline/tknot.html) Knot sequence used to define the spline basis.
  + [`x`](/spline-core/classes/constrainedspline/x.html) Observation values used to fit the spline.
  + [`x_mean`](/spline-core/classes/constrainedspline/x_mean.html) Mean added back to zero-order spline evaluations.
  + [`x_std`](/spline-core/classes/constrainedspline/x_std.html) Multiplicative scale applied to spline evaluations.
  + [`xi`](/spline-core/classes/constrainedspline/xi.html) Spline coefficients as an Mx1 vector.


---