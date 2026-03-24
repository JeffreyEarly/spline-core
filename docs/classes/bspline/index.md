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

Create, evaluate, and manipulate one-dimensional terminated B-splines.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef BSpline < handle</code></pre></div></div>

## Overview

`BSpline` is the low-level one-dimensional spline object used by the
higher-level interpolation and fitting classes. It stores a spline
degree `S`, a terminated knot sequence `knotPoints`, and a coefficient
vector `xi`, then caches an equivalent piecewise-polynomial
representation for fast evaluation.

Mathematically, the stored spline is

$$
f(t) = x_{\mathrm{Mean}} + x_{\mathrm{Std}} \sum_{j=1}^{M} \xi_j B_{j,S}(t;\tau),
$$

where $$\tau$$ is the terminated knot sequence, $$B_{j,S}$$ are the
one-dimensional B-spline basis functions of degree $$S$$, and
`xMean` is added only for zero-order evaluation.

## Basic usage

In most workflows you first build a knot sequence from sample
locations, assemble the spline basis matrix, solve for coefficients,
and then evaluate the resulting spline object.

```matlab
t = linspace(0,1,20)';
x = sin(2*pi*t);
knotPoints = BSpline.knotPointsForDataPoints(t, S=3);
X = BSpline.matrixForDataPoints(t, knotPoints=knotPoints, S=3);
spline = BSpline(S=3, knotPoints=knotPoints, xi=X\x);

xq = spline(linspace(0,1,100)');
```





## Topics
+ Create a spline
  + [`BSpline`](/spline-core/classes/bspline/bspline.html) Create a one-dimensional spline from degree, knots, and coefficients.
+ Inspect spline properties
  + [`K`](/spline-core/classes/bspline/k.html) Spline order K, where polynomial degree is S = K - 1.
  + [`S`](/spline-core/classes/bspline/s.html) Polynomial degree S = K - 1.
  + [`domain`](/spline-core/classes/bspline/domain.html) Minimum and maximum values of the spline domain.
  + [`knotPoints`](/spline-core/classes/bspline/knotpoints.html) Knot sequence used to define the spline basis.
  + [`xMean`](/spline-core/classes/bspline/xmean.html) Mean added back to zero-order spline evaluations.
  + [`xStd`](/spline-core/classes/bspline/xstd.html) Multiplicative scale applied to spline evaluations.
  + [`xi`](/spline-core/classes/bspline/xi.html) Spline coefficients as an Mx1 vector.
+ Evaluate the spline
  + [`feval`](/spline-core/classes/bspline/feval.html) Evaluate a B-spline at the supplied points.
  + [`subsref`](/spline-core/classes/bspline/subsref.html) Evaluate the spline with function-call syntax or defer to built-in indexing.
  + [`valueAtPoints`](/spline-core/classes/bspline/valueatpoints.html) Evaluate the spline or one of its derivatives at arbitrary points.
+ Transform the spline
  + [`cumsum`](/spline-core/classes/bspline/cumsum.html) Return the indefinite integral of a B-spline.
  + [`diff`](/spline-core/classes/bspline/diff.html) Differentiate a B-spline representation.
  + [`mtimes`](/spline-core/classes/bspline/mtimes.html) Multiply a spline output by a scalar.
  + [`plus`](/spline-core/classes/bspline/plus.html) Add a scalar offset to a spline output.
  + [`power`](/spline-core/classes/bspline/power.html) Raise spline values to a real scalar power by refitting support values.
  + [`roots`](/spline-core/classes/bspline/roots.html) Return real roots of a spline within its domain.
  + [`sqrt`](/spline-core/classes/bspline/sqrt.html) Return a spline approximation to the square root of the spline output.
+ Build spline bases
  + [`knotPointsForDataPoints`](/spline-core/classes/bspline/knotpointsfordatapoints.html) Construct a terminated knot sequence from sample locations.
  + [`matrixForDataPoints`](/spline-core/classes/bspline/matrixfordatapoints.html) Evaluate terminated B-spline basis functions and optional derivatives.
  + [`pointsOfSupportFromKnotPoints`](/spline-core/classes/bspline/pointsofsupportfromknotpoints.html) Return representative support points for a terminated spline basis.


## Developer Topics
These items document internal implementation details and are not part of the primary public API.
+ Represent piecewise polynomials
  + [`C`](/spline-core/classes/bspline/c.html) Piecewise-polynomial coefficients for interval evaluation.
  + [`Xtpp`](/spline-core/classes/bspline/xtpp.html) Basis values and derivatives sampled at piecewise breakpoints.
  + [`evaluateFromPPCoefficients`](/spline-core/classes/bspline/evaluatefromppcoefficients.html) Evaluate a cached piecewise-polynomial spline representation.
  + [`ppCoefficientsFromSplineCoefficients`](/spline-core/classes/bspline/ppcoefficientsfromsplinecoefficients.html) Convert spline coefficients into piecewise-polynomial interval coefficients.
  + [`t_pp`](/spline-core/classes/bspline/t_pp.html) Piecewise-polynomial breakpoint locations.
+ Maintain cached state
  + [`splineCoefficientsDidChange`](/spline-core/classes/bspline/splinecoefficientsdidchange.html) Refresh cached polynomial coefficients after coefficient updates.
  + [`tKnotDidChange`](/spline-core/classes/bspline/tknotdidchange.html) Clear cached piecewise-polynomial data after knot updates.


---