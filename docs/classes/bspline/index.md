---
layout: default
title: BSpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 1
---

#  BSpline

Create, evaluate, and manipulate terminated B-spline representations.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef BSpline < handle</code></pre></div></div>

## Overview
 
BSpline stores a spline basis order, knot sequence, and spline
coefficients together with cached piecewise-polynomial coefficients for
efficient evaluation, differentiation, and algebraic transforms.
 
           



## Topics
+ Initialization
  + [`BSpline`](/spline-core/classes/bspline/bspline.html) Create a new B-spline representation from order, knots, and coefficients.
+ Primary attributes
  + [`K`](/spline-core/classes/bspline/k.html) Spline order K, where polynomial degree is S = K - 1.
  + [`S`](/spline-core/classes/bspline/s.html) Polynomial degree S = K - 1.
  + [`domain`](/spline-core/classes/bspline/domain.html) Minimum and maximum values of the spline domain.
  + [`tKnot`](/spline-core/classes/bspline/tknot.html) Knot sequence used to define the spline basis.
  + [`xMean`](/spline-core/classes/bspline/xmean.html) Mean added back to zero-order spline evaluations.
  + [`xStd`](/spline-core/classes/bspline/xstd.html) Multiplicative scale applied to spline evaluations.
  + [`xi`](/spline-core/classes/bspline/xi.html) Spline coefficients as an Mx1 vector.
+ Spline evaluation
  + [`C`](/spline-core/classes/bspline/c.html) Piecewise-polynomial coefficients for interval evaluation.
  + [`Xtpp`](/spline-core/classes/bspline/xtpp.html) Basis values and derivatives sampled at piecewise breakpoints.
  + [`evaluateFromPPCoefficients`](/spline-core/classes/bspline/evaluatefromppcoefficients.html) Returns the value of the function with derivative D represented by PP coefficients C at locations t.
  + [`matrix`](/spline-core/classes/bspline/matrix.html) Evaluate terminated B-spline basis functions and optional derivatives.
  + [`ppCoefficientsFromSplineCoefficients`](/spline-core/classes/bspline/ppcoefficientsfromsplinecoefficients.html) Returns the piecewise polynomial coefficients in matrix C from spline coefficients in vector xi.
  + [`t_pp`](/spline-core/classes/bspline/t_pp.html) Piecewise-polynomial breakpoint locations.
+ Operations
  + [`cumsum`](/spline-core/classes/bspline/cumsum.html) Return the indefinite integral of a B-spline.
  + [`diff`](/spline-core/classes/bspline/diff.html) Differentiate a B-spline representation.
  + [`feval`](/spline-core/classes/bspline/feval.html) Evaluate a B-spline at the supplied points.
  + [`mtimes`](/spline-core/classes/bspline/mtimes.html) Multiply a spline output by a scalar.
  + [`plus`](/spline-core/classes/bspline/plus.html) Add a scalar offset to a spline output.
  + [`power`](/spline-core/classes/bspline/power.html) Raise spline values to a real scalar power by refitting support values.
  + [`roots`](/spline-core/classes/bspline/roots.html) Return real roots of a spline within its domain.
  + [`sqrt`](/spline-core/classes/bspline/sqrt.html) Return a spline approximation to the square root of the spline output.
  + [`subsref`](/spline-core/classes/bspline/subsref.html) Evaluate the spline with function-call syntax or defer to built-in indexing.
  + [`valueAtPoints`](/spline-core/classes/bspline/valueatpoints.html) Evaluate the spline or one of its derivatives at arbitrary points.
+ Utility
  + [`pointsOfSupport`](/spline-core/classes/bspline/pointsofsupport.html) Return representative support points for a terminated spline basis.
  + [`splineCoefficientsDidChange`](/spline-core/classes/bspline/splinecoefficientsdidchange.html) Refresh cached polynomial coefficients after coefficient updates.
  + [`tKnotDidChange`](/spline-core/classes/bspline/tknotdidchange.html) Clear cached piecewise-polynomial data after knot updates.
+ Methodology (Static methods)
  + [`knotPointsForDataPoints`](/spline-core/classes/bspline/knotpointsfordatapoints.html) Construct a terminated knot sequence from sample locations.


---