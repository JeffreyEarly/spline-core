---
layout: default
title: Tutorials
nav_order: 5
has_children: true
mathjax: true
permalink: /tutorials
---

# Tutorials

These examples are written as plain MATLAB scripts and are rendered into website pages during the documentation build.

## Available Tutorials

- [Interpolating Spline Basics](./interpolating-spline-basics)
  Construct and evaluate one-dimensional and tensor-product interpolating splines.
- [Introduction to B-splines](./introduction-to-b-splines)
  Build intuition for spline order, knot placement, interpolation, and B-spline basis functions through the first two canonical spline figures.
- [Robust Fitting of Noisy Data](./robust-spline-fitting)
  Compare ordinary least squares and Student-t IRLS when fitting a spline to noisy data with outliers.
- [Local Point Constraints in 1D](./local-point-constraints-1d)
  Apply value and derivative equality constraints at one or more points in a one-dimensional spline fit.
- [Global Shape Constraints](./global-shape-constraints)
  Enforce positivity and monotonicity over an entire domain with GlobalConstraint objects.
- [Mask-Constrained Tensor Fits](./mask-constrained-fit)
  Impose value and derivative constraints over an entire masked region using PointConstraint helper methods.
- [Scattered Data Fitting in 2D](./scattered-data-fitting-2d)
  Fit a tensor-product spline to scattered two-dimensional observations and use dataDOF to control knot density in each coordinate direction.
