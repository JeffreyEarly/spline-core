---
layout: default
title: Home
nav_order: 1
description: "Core B-spline, interpolation, and constrained fitting tools for MATLAB"
permalink: /
---

# Spline Core
## B-spline construction, interpolation, and constrained fitting for MATLAB.

`Spline Core` is a MATLAB package for building and manipulating B-spline
models, exact interpolants on one-dimensional and rectilinear grids, and
constrained tensor-product fits for noisy data.

- [Install](installation) the package
- Read the [Getting Started](getting-started) guide
- Use [Which Class Should I Use?](which-class-should-i-use) if you want the shortest path to the right API
- Work through the runnable [Tutorials](tutorials)
- Browse [Common Tasks](common-tasks)
- See [Compared with MATLAB](compared-with-matlab)
- Use the [Class documentation](classes)

---

## Start Here

Choose the class that matches the problem you are solving.

- [`BSpline`](classes/bspline): low-level one-dimensional spline basis construction, evaluation, derivatives, roots, and transforms.
- [`InterpolatingSpline`](classes/interpolatingspline): exact interpolation in one dimension or on rectilinear tensor grids.
- [`ConstrainedSpline`](classes/constrainedspline): noisy-data fitting, robust fitting, local constraints, and global shape constraints.
- [`TensorSpline`](classes/tensorspline): lower-level tensor-product spline representation used by the higher-level classes.

If you are not sure where to begin, most users should start with:

- `InterpolatingSpline` for exact interpolation
- `ConstrainedSpline` for noisy or constrained fitting

For a slightly more detailed guide, see [Which Class Should I Use?](which-class-should-i-use).

## Core Capabilities

- Exact interpolation in 1D and on rectilinear tensor grids
- Tensor-product fitting for noisy data in one or more dimensions
- Robust fitting through IRLS with alternate error models
- Local value and derivative constraints through `PointConstraint`
- Global positivity and monotonicity constraints through `GlobalConstraint`
- Low-level access to basis matrices, knot placement, derivatives, integrals, roots, and spline transforms

## A Typical Low-Level Workflow

The figure below shows a terminated B-spline basis generated from a knot
sequence and evaluated on a dense grid.

<img src="figures/bspline.png" alt="B-spline basis functions and derivatives" width="400">

The same basis can be created with a few lines of code:

```matlab
K = 4;
t = (0:10)';
tKnot = [repmat(t(1), K-1, 1); t; repmat(t(end), K-1, 1)];
xi = zeros(numel(tKnot) - K, 1);
xi(4) = 1;

spline = BSpline(K, tKnot, xi);
tDense = linspace(t(1), t(end), 500)';
plot(tDense, spline(tDense), "LineWidth", 2)
```

## Why Not Just Use MATLAB Built-ins?

MATLAB already has useful interpolation and fitting tools. The main reason
to use `Spline Core` is that it keeps those familiar workflows, but then
extends them into a single spline framework.

- `InterpolatingSpline` is similar in spirit to `interp1` in 1D and `griddedInterpolant` on rectilinear grids, but it gives you an inspectable spline object with knots, coefficients, derivatives, roots, and basis access.
- `ConstrainedSpline` can reproduce the least-squares polynomial role of `polyfit`, but it also moves naturally into richer spline spaces, robust fitting, and local/global constraints.
- In 1D, knot placement is data-driven. Canonical spline knots are chosen from the sample locations, so irregularly spaced data are a first-class use case rather than a corner case.

See [Compared with MATLAB](compared-with-matlab) for side-by-side examples.

## A Practical Difference: Robust Fitting

One of the clearest places where the package goes beyond MATLAB's basic
interpolation tools is robust spline fitting. The same `ConstrainedSpline`
object can fit noisy data with ordinary least squares or with a robust
distribution model, while still supporting the same spline-centric API.

<img src="tutorials/robust-spline-fitting/robust-fit-comparison.png" alt="Comparison of ordinary least squares and robust spline fitting" width="700">

The corresponding workflow is:

```matlab
leastSquaresFit = ConstrainedSpline(t, x, K=4, dataDOF=2);
robustFit = ConstrainedSpline(t, x, ...
    K=4, ...
    dataDOF=2, ...
    distribution=StudentTDistribution(sigma=0.1, nu=3));
```

## A Second Difference: Tensor Constraints

The same framework also supports constraints over many points at once. For
example, a masked region on a tensor grid can be converted into local
value and derivative constraints and then fit in one solve.

<img src="tutorials/mask-constrained-fit/mask-constrained-fit.png" alt="Tensor fit with constraints applied over a masked region" width="700">

This is a good example of the package's scope: it is not just a collection
of interpolation routines, but a spline framework for fitting and
constraining models built from the same underlying basis.

## One Important Modeling Boundary

In more than one dimension:

- `InterpolatingSpline` performs exact interpolation on rectilinear tensor grids
- `ConstrainedSpline` fits tensor-product models to point clouds, including scattered observations

That distinction is intentional. It keeps exact interpolation and noisy
fitting clean while still using one coherent spline framework.
