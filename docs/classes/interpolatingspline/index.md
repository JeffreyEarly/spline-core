---
layout: default
title: InterpolatingSpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 2
---

#  InterpolatingSpline

Interpolating spline fit through data values.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef InterpolatingSpline < BSpline</code></pre></div></div>

## Overview
 
Supported construction forms:
  f = InterpolatingSpline(t,x)
  f = InterpolatingSpline(t,x,K=K)
  f = InterpolatingSpline(t,x,S=S)
 
The constructor chooses a terminated knot sequence from the supplied
sample locations and solves for coefficients that interpolate the
provided values exactly.
 
    


## Topics
+ Initialization
  + [`InterpolatingSpline`](/spline-core/classes/interpolatingspline/interpolatingspline.html) Create an interpolating spline through samples x observed at t.
+ Utility
  + [`pointsOfSupport`](/spline-core/classes/interpolatingspline/pointsofsupport.html) Return representative support points for a terminated spline basis.
  + [`splineCoefficientsDidChange`](/spline-core/classes/interpolatingspline/splinecoefficientsdidchange.html) Refresh cached polynomial coefficients after coefficient updates.
  + [`splineOrderFromOptions`](/spline-core/classes/interpolatingspline/splineorderfromoptions.html) Resolve spline order from mutually exclusive K and S options.
  + [`tKnotDidChange`](/spline-core/classes/interpolatingspline/tknotdidchange.html) Clear cached piecewise-polynomial data after knot updates.
+ Spline evaluation
  + [`C`](/spline-core/classes/interpolatingspline/c.html) Piecewise-polynomial coefficients for interval evaluation.
  + [`Xtpp`](/spline-core/classes/interpolatingspline/xtpp.html) Basis values and derivatives sampled at piecewise breakpoints.
  + [`evaluateFromPPCoefficients`](/spline-core/classes/interpolatingspline/evaluatefromppcoefficients.html) Returns the value of the function with derivative D represented by PP coefficients C at locations t.
  + [`matrix`](/spline-core/classes/interpolatingspline/matrix.html) Evaluate terminated B-spline basis functions and optional derivatives.
  + [`ppCoefficientsFromSplineCoefficients`](/spline-core/classes/interpolatingspline/ppcoefficientsfromsplinecoefficients.html) Returns the piecewise polynomial coefficients in matrix C from spline coefficients in vector xi.
  + [`t_pp`](/spline-core/classes/interpolatingspline/t_pp.html) Piecewise-polynomial breakpoint locations.
+ Primary attributes
  + [`K`](/spline-core/classes/interpolatingspline/k.html) Spline order K, where polynomial degree is S = K - 1.
  + [`S`](/spline-core/classes/interpolatingspline/s.html) Polynomial degree S = K - 1.
  + [`domain`](/spline-core/classes/interpolatingspline/domain.html) Minimum and maximum values of the spline domain.
  + [`tKnot`](/spline-core/classes/interpolatingspline/tknot.html) Knot sequence used to define the spline basis.
  + [`x_mean`](/spline-core/classes/interpolatingspline/x_mean.html) Mean added back to zero-order spline evaluations.
  + [`x_std`](/spline-core/classes/interpolatingspline/x_std.html) Multiplicative scale applied to spline evaluations.
  + [`xi`](/spline-core/classes/interpolatingspline/xi.html) Spline coefficients as an Mx1 vector.
+ Operations
  + [`cumsum`](/spline-core/classes/interpolatingspline/cumsum.html) Return the indefinite integral of a B-spline.
  + [`diff`](/spline-core/classes/interpolatingspline/diff.html) Differentiate a B-spline representation.
  + [`feval`](/spline-core/classes/interpolatingspline/feval.html) Evaluate a B-spline at the supplied points.
  + [`mtimes`](/spline-core/classes/interpolatingspline/mtimes.html) Multiply a spline output by a scalar.
  + [`plus`](/spline-core/classes/interpolatingspline/plus.html) Add a scalar offset to a spline output.
  + [`power`](/spline-core/classes/interpolatingspline/power.html) Raise spline values to a real scalar power by refitting support values.
  + [`roots`](/spline-core/classes/interpolatingspline/roots.html) Return real roots of a spline within its domain.
  + [`sqrt`](/spline-core/classes/interpolatingspline/sqrt.html) Return a spline approximation to the square root of the spline output.
  + [`subsref`](/spline-core/classes/interpolatingspline/subsref.html) Evaluate the spline with function-call syntax or defer to built-in indexing.
  + [`valueAtPoints`](/spline-core/classes/interpolatingspline/valueatpoints.html) Evaluate the spline or one of its derivatives at arbitrary points.
+ Methodology (Static methods)
  + [`knotPointsForDataPoints`](/spline-core/classes/interpolatingspline/knotpointsfordatapoints.html) Construct a terminated knot sequence from sample locations.


---