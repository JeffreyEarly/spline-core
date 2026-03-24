---
layout: default
title: Home
nav_order: 1
description: "Spline interpolation and constrained fitting tools for MATLAB"
permalink: /
---

# Spline Core

Spline interpolation, smoothing, and constrained fitting for MATLAB.

`Spline Core` brings exact interpolation, noisy-data fitting, robust error
models, and low-level spline-basis tools into one consistent MATLAB object
model. It is a good fit when you want something closer to `interp1`,
`griddedInterpolant`, and `polyfit`, but with reusable spline objects and
built-in support for constraints.

<img src="./figures/bspline.png" alt="B-spline basis functions and their first derivatives" width="760">

## Start Here

- [Getting Started](getting-started) for the shortest path from installation to a first interpolation or fit
- [Tutorials](tutorials) for guided workflows
- [Common Tasks](common-tasks) for task-oriented entry points
- [Class Documentation](classes) for method-level reference
- [Compared with MATLAB](compared-with-matlab) for direct built-in comparisons

## Choose a starting point

| Class | Start here when | Typical result |
| --- | --- | --- |
| [`InterpolatingSpline`](classes/interpolatingspline) | your data should be matched exactly in 1D or on a rectilinear grid | an exact spline interpolant |
| [`ConstrainedSpline`](classes/constrainedspline) | your data are noisy or you need robust fitting or constraints | a fitted spline model |
| [`BSpline`](classes/bspline) | you want direct control over 1D knot vectors, basis matrices, or coefficients | a low-level 1D spline representation |
| [`TensorSpline`](classes/tensorspline) | you want the tensor-product analogue of `BSpline` | a low-level multidimensional spline representation |

## What the package adds

- exact interpolation and noisy fitting live in the same spline family
- local point constraints and global shape constraints use the same fitting API
- robust fitting is available through alternate error models such as `StudentTDistribution`
- low-level basis access remains available when you need custom regression or inverse-problem workflows
