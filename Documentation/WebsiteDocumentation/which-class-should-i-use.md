---
layout: default
title: Which Class Should I Use?
parent: Getting Started
nav_order: 1
description: "A short guide to choosing the right spline class"
permalink: /which-class-should-i-use
---

# Which Class Should I Use?

Most users only need to answer one question first: are you interpolating
exact data, or fitting noisy data?

If the data should be matched exactly, start with
[`InterpolatingSpline`](classes/interpolatingspline). If the data are noisy,
or if you need robust fitting or constraints, start with
[`ConstrainedSpline`](classes/constrainedspline).

## The Short Version

| Problem | Class | MATLAB analogue | What changes here |
| --- | --- | --- | --- |
| Build or inspect a 1D spline basis directly | [`BSpline`](classes/bspline) | none directly | You work with knots, coefficients, basis matrices, roots, and transforms explicitly. |
| Interpolate exact 1D data | [`InterpolatingSpline`](classes/interpolatingspline) | `interp1`, `spline` | Returns a spline object rather than only values. |
| Interpolate exact data on a rectilinear grid | [`InterpolatingSpline`](classes/interpolatingspline) | `griddedInterpolant` | Same basic problem, but with the same spline object model as the rest of the package. |
| Fit noisy data in 1D or higher dimensions | [`ConstrainedSpline`](classes/constrainedspline) | `polyfit` for simple 1D polynomial fits | Extends naturally to splines, robust fitting, and constraints. |
| Add local value or derivative constraints | [`ConstrainedSpline`](classes/constrainedspline) with [`PointConstraint`](classes/constraints/pointconstraint) | none directly | Constrain the fitted spline at specific points. |
| Add global positivity or monotonicity constraints | [`ConstrainedSpline`](classes/constrainedspline) with [`GlobalConstraint`](classes/constraints/globalconstraint) | none directly | Constrain the fit over the whole model domain. |
| Work with tensor-product spline objects directly | [`TensorSpline`](classes/tensorspline) | none directly | Lower-level tensor basis, evaluation, and transforms. |

## The Main Distinction

`InterpolatingSpline` is for exact interpolation. In one dimension, it
chooses canonical spline knots from the sample locations and then solves
for the spline coefficients so that the spline matches the data exactly.
That is one reason it works naturally with irregularly spaced data.

```matlab
t = sort(rand(20,1));
x = sin(2*pi*t);
f = InterpolatingSpline(t, x, K=4);
```

`ConstrainedSpline` is for fitting. It uses the same underlying spline
model, but now the coefficients are chosen to fit noisy observations. This
is where robust fitting, local constraints, and global shape constraints
come in.

```matlab
t = sort(rand(50,1));
x = exp(t) + 0.05*randn(size(t));
fit = ConstrainedSpline(t, x, K=4, dataDOF=2);
```

## If You Are Coming from MATLAB

If you usually reach for `interp1` or `griddedInterpolant`, start with
`InterpolatingSpline`.

If you usually reach for `polyfit`, start with `ConstrainedSpline`. In one
dimension, `ConstrainedSpline(t, x, K=N, splineDOF=N)` matches the
least-squares polynomial fit from `polyfit(t, x, N-1)`, but it also gives
you a direct path into richer spline spaces and constraints.

## If You Want the Low-Level Model

Use `BSpline` in 1D and `TensorSpline` in higher dimensions when you want
direct access to basis matrices, knot vectors, spline coefficients, and
transform operations.

That is usually the right choice for custom regression, inverse problems,
or when you want to work with the spline representation itself rather than
just fitting data.

## Where to Go Next

- Read [Getting Started](getting-started) for the short package walkthrough.
- See [Common Tasks](common-tasks) for task-oriented entry points.
- Read [Compared with MATLAB](compared-with-matlab) for direct comparisons with built-in functions.
- Browse [Class documentation](classes) when you need method-level reference.
