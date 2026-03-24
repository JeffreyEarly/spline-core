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

## The short version

| Problem | Class | MATLAB analogue | Why start there |
| --- | --- | --- | --- |
| Build or inspect a 1D spline basis directly | [`BSpline`](classes/bspline) | none directly | You work with knots, coefficients, basis matrices, roots, and transforms explicitly. |
| Interpolate exact 1D data | [`InterpolatingSpline`](classes/interpolatingspline) | `interp1`, `spline` | Returns a reusable spline object rather than only values. |
| Interpolate exact data on a rectilinear grid | [`InterpolatingSpline`](classes/interpolatingspline) | `griddedInterpolant` | Uses the same spline object model as the rest of the package. |
| Fit noisy 1D or rectilinear-grid data | [`ConstrainedSpline`](classes/constrainedspline) | `polyfit` for simple 1D least-squares fits | Extends naturally to splines, robust fitting, and constraints. |
| Add local value or derivative constraints | [`ConstrainedSpline`](classes/constrainedspline) with [`PointConstraint`](classes/constraints/pointconstraint) | none directly | Constrain the fitted spline at specific points. |
| Add global positivity or monotonicity constraints | [`ConstrainedSpline`](classes/constrainedspline) with [`GlobalConstraint`](classes/constraints/globalconstraint) | none directly | Constrain the fit over the whole model domain. |
| Work with tensor-product spline objects directly | [`TensorSpline`](classes/tensorspline) | none directly | Lower-level tensor basis, evaluation, and transforms. |

## Exact interpolation

`InterpolatingSpline` is for exact interpolation. In one dimension, it
chooses canonical spline knots from the sample locations and solves for
coefficients so that the spline matches the supplied values exactly.

```matlab
t = sort(rand(20,1));
x = sin(2*pi*t);
f = InterpolatingSpline(t, x, S=3);
```

For rectilinear grids, pass one grid vector per dimension:

```matlab
F = InterpolatingSpline({x, y}, V, S=[3 3]);
Vq = F(Xq, Yq);
```

## Noisy fitting and constraints

`ConstrainedSpline` uses the same spline family for noisy-data fitting.
This is where robust fitting, local point constraints, and global shape
constraints enter the workflow.

```matlab
t = sort(rand(50,1));
x = exp(t) + 0.05*randn(size(t));
fit = ConstrainedSpline(t, x, S=3, splineDOF=12);
```

In higher dimensions, use `ConstrainedSpline({x, y}, values, ...)` for
rectilinear grids.

If you usually think in terms of `polyfit`, the direct alignment is:

- `polyfit(t, x, N-1)` corresponds to `ConstrainedSpline(t, x, S=N-1, splineDOF=N)`

## Low-level spline work

Use `BSpline` in 1D and `TensorSpline` in higher dimensions when you want
direct access to basis matrices, knot vectors, coefficients, or transform
operations.

That is usually the right choice for custom regression, inverse problems,
or when you want to work with the spline representation itself rather than
starting from a high-level interpolation or fitting workflow.

## Where to go next

- Read [Getting Started](getting-started) for the short package walkthrough
- See [Common Tasks](common-tasks) for task-oriented entry points
- Read [Compared with MATLAB](compared-with-matlab) for direct built-in comparisons
- Browse [Class Documentation](classes) for method-level reference
