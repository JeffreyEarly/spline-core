---
layout: default
title: Home
nav_order: 1
description: "Spline interpolation and constrained fitting tools for MATLAB"
permalink: /
---

# Spline Core

Spline interpolation and constrained fitting for MATLAB.

`Spline Core` extends MATLAB's interpolation and fitting tools into a
spline framework for robust fitting and constraints.

<img src="tutorials/robust-fitting-with-outliers/robust-fit-comparison.png" alt="Comparison of ordinary least squares and robust spline fitting" width="760">

## Features

- [`InterpolatingSpline`](classes/interpolatingspline) plays a role similar to `interp1` in 1D and `griddedInterpolant`.
- [`ConstrainedSpline`](classes/constrainedspline) can recover the same least-squares polynomial fit as `polyfit`.
- [`TrajectorySpline`](classes/trajectoryspline) fits and persists planar `x(t), y(t)` trajectories with shared-parameter derivative helpers.
- In 1D, spline knots are chosen from the sample locations, so irregularly spaced data are handled naturally.
- `ConstrainedSpline` supports robust fitting, local point constraints, and global positivity or monotonicity constraints in the same API.

## The Main Classes

| Class | Use it for |
| --- | --- |
| [`InterpolatingSpline`](classes/interpolatingspline) | exact interpolation in 1D and on rectilinear tensor grids |
| [`ConstrainedSpline`](classes/constrainedspline) | noisy-data fitting, robust fitting, and local or global constraints |
| [`TrajectorySpline`](classes/trajectoryspline) | planar trajectory fitting and persistence with shared-parameter component splines |
| [`BSpline`](classes/bspline) | low-level one-dimensional spline basis construction and analysis |
| [`TensorSpline`](classes/tensorspline) | low-level tensor-product spline construction and analysis |
