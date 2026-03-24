---
layout: default
title: Class documentation
nav_order: 6
has_children: true
permalink: /classes
---

# Class Documentation

This section is the reference manual for the spline classes and
constraint objects. Use it when you want the exact constructor,
property, method, or equation used by a class.

If you are still choosing an approach, start with
[Which Class Should I Use?](../which-class-should-i-use) or the
[Tutorials](../tutorials) before dropping into the reference.

## Choose a starting point

| Class | Use it when | Typical job |
| --- | --- | --- |
| [`InterpolatingSpline`](./interpolatingspline) | your values are trusted exactly and lie on a 1-D grid or rectilinear tensor grid | exact interpolation |
| [`ConstrainedSpline`](./constrainedspline) | your data are noisy, weighted, or subject to point or global constraints | smoothing and constrained fitting |
| [`BSpline`](./bspline) | you want direct access to one-dimensional basis matrices, derivatives, knot utilities, or PP coefficients | low-level 1-D spline work |
| [`TensorSpline`](./tensorspline) | you want the multidimensional tensor-product analogue of `BSpline` | low-level tensor-product spline work |

Most users should start with [`InterpolatingSpline`](./interpolatingspline)
or [`ConstrainedSpline`](./constrainedspline). The lower-level
[`BSpline`](./bspline) and [`TensorSpline`](./tensorspline) pages are
mainly for building custom workflows, understanding the mathematics, or
working directly with spline bases and coefficients.

## How the classes relate

- [`BSpline`](./bspline) is the core one-dimensional spline object.
- [`TensorSpline`](./tensorspline) extends the same construction to multiple dimensions by taking tensor products of one-dimensional bases.
- [`InterpolatingSpline`](./interpolatingspline) is the exact-fit constructor built on top of `TensorSpline`.
- [`ConstrainedSpline`](./constrainedspline) is the noisy-data fitting constructor built on top of `TensorSpline`, with weights, robust distributions, and constraints.

## Constraint objects

These helper classes support
[`ConstrainedSpline`](./constrainedspline):

- [`SplineConstraint`](./constraints/splineconstraint)
- [`PointConstraint`](./constraints/pointconstraint)
- [`GlobalConstraint`](./constraints/globalconstraint)

## Shared notation

The reference pages use the same notation throughout so the equations,
examples, and property names line up.

| Symbol | Meaning | API name |
| --- | --- | --- |
| $$S$$ | spline degree | `S` |
| $$K = S + 1$$ | spline order | `K` |
| $$\tau$$ | knot vector in 1-D, or knot vectors per dimension in tensor splines | `knotPoints` |
| $$\xi$$ | spline coefficients | `xi` |
| $$B$$ | one-dimensional basis matrix | returned by `BSpline.matrixForDataPoints` |
| $$\mathbf{B}$$ | tensor-product basis matrix or fitting system matrix | returned by `TensorSpline.matrixForPointMatrix` or built inside fitting classes |
| $$xMean$$, $$xStd$$ | affine output normalization | `xMean`, `xStd` |

When a class stores affine normalization, zero-order evaluation is
written as an additive offset plus a scaled spline expansion. Derivative
expressions keep the `xStd` scaling and drop the `xMean` offset.

## Reading the reference

Each class page emphasizes the methods and properties declared by that
class. Inherited behavior lives on the parent-class page, so higher-level
pages stay shorter and easier to scan:

- [`InterpolatingSpline`](./interpolatingspline) and [`ConstrainedSpline`](./constrainedspline) inherit most evaluation and transformation behavior from [`TensorSpline`](./tensorspline).
- [`TensorSpline`](./tensorspline) mirrors many one-dimensional ideas from [`BSpline`](./bspline), but does not duplicate the full `BSpline` reference.
