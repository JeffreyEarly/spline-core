---
layout: default
title: Tutorials
nav_order: 5
has_children: true
mathjax: true
permalink: /tutorials
---

# Tutorials

Read these tutorials in order. The first six cover interpolation, fitting, and constraints; the final two explain the low-level BSpline and TensorSpline APIs.

## Available Tutorials

- [Interpolation in 1D and on Rectilinear Grids](./interpolation-on-grids)
  Interpolate exact data in one dimension and on rectilinear grids, and compare the results with MATLAB's griddedInterpolant.
- [Fitting Noisy Data](./fitting-noisy-data)
  Fit a smooth spline to noisy observations with a normal noise model and explore the effect of spline complexity.
- [Robust Fitting with Outliers](./robust-fitting-with-outliers)
  Replace a normal noise model with a Student-t model when a few observations are badly contaminated.
- [Local Point Constraints](./local-point-constraints)
  Apply value, slope, and curvature constraints at specific points in a one-dimensional spline fit.
- [Global Shape Constraints](./global-shape-constraints)
  Enforce positivity and monotonicity over an entire one-dimensional domain.
- [2D Constraints on Rectilinear Grids](./rectilinear-grid-constraints-2d)
  Apply a global monotonicity constraint along one dimension of a noisy tensor-product fit.
- [BSpline Foundations](./bspline-foundations)
  Build intuition for order, degree, knot placement, local support, and basis construction in one dimension.
- [TensorSpline Foundations](./tensorspline-foundations)
  Understand tensor-product spline coefficients, basis matrices, and mixed partial derivatives.
