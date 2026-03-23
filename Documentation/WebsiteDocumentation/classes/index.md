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
