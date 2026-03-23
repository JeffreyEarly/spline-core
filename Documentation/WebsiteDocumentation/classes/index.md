---
layout: default
title: Class documentation
nav_order: 6
has_children: true
permalink: /classes
---

# Class Documentation

Method and property reference pages for the public spline classes are
generated from the class annotations in the MATLAB source.

If you are deciding where to start, read [Which Class Should I Use?](../which-class-should-i-use)
before dropping into the method-level reference.

## Start with the highest-level class that matches your problem

- [`InterpolatingSpline`](./interpolatingspline): exact interpolation in one dimension or on a rectilinear tensor grid
- [`ConstrainedSpline`](./constrainedspline): noisy-data fitting, robust fitting, and local/global constraints
- [`BSpline`](./bspline): low-level one-dimensional basis and spline operations
- [`TensorSpline`](./tensorspline): low-level tensor-product spline operations

## Shared notation

The core spline classes use the same notation throughout the generated
reference so that equations, MATLAB examples, and property names match.

- spline degree: $$S$$
- spline order: $$K = S + 1$$
- knot sequence or tensor-product knot cell: $$\tau$$, exposed in the API as `knotPoints`
- spline coefficients: $$\xi$$, exposed in the API as `xi`
- one-dimensional coordinates: $$t$$
- tensor grid vectors: $$x_1,\ldots,x_d$$
- matching query arrays: $$X_1,\ldots,X_d$$
- derivative orders: $$D$$
- observed values in fitting problems: $$y$$
- basis matrices: $$B$$ in one dimension and $$\mathbf{B}$$ for tensor-product systems

When a class stores affine output normalization, the formulas in the
reference treat `xMean` as an additive offset applied only to zero-order
evaluation and `xStd` as a multiplicative scale applied to values and
derivatives.

## Constraint classes

Constraint objects live in their own section because they support
`ConstrainedSpline` rather than standing alone.

- [`SplineConstraint`](./constraints/splineconstraint)
- [`PointConstraint`](./constraints/pointconstraint)
- [`GlobalConstraint`](./constraints/globalconstraint)

## How the reference is organized

Subclass pages focus on methods declared by that class, so tensor and
constrained spline classes do not repeat the full `BSpline` or
`TensorSpline` method surface. That keeps the higher-level API pages
shorter and easier to scan.
